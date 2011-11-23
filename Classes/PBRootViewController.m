#import "PBRootViewController.h"
#import "PBRefreshTableHeaderView.h"
#import "ASIDownloadCache.h"
#import "PBProgressHUD.h"
#import "AppDelegate.h"


@interface PBRootViewController (Private)

- (void)dataSourceDidFinishLoadingNewData;

@end


@implementation PBRootViewController

@synthesize data = _data;
@synthesize reloading = _reloading;
@synthesize baseURL = _baseURL;
@synthesize responseData = _responseData;
@synthesize pullsToRefresh = _pullsToRefresh;

- (NSURL *) url {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.baseURL]];
}


- (void)viewDidLoad {
  [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated {
  if (self.pullsToRefresh) {
    if (!refreshHeaderView) {
      refreshHeaderView = [[PBRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
      [self.tableView addSubview:refreshHeaderView];
      self.tableView.showsVerticalScrollIndicator = YES;
      [refreshHeaderView release];
    }
  }
  if (!self.tableView.tableFooterView) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = view;
    [view release];
  }
  if (!self.navigationItem.title) {
     self.navigationItem.title  = @" ";
  }
 
  if ([self.data count] < 1) {
    [self loadDataFromCacheIfAvailable];
  }  
} 

- (void) viewWillDisappear:(BOOL)animated {
  [[ASIHTTPRequest sharedQueue] cancelAllOperations];
}


//Release
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	refreshHeaderView = nil;
}


-(BOOL) cachedDataAvailable {
  NSDictionary *headers = [[ASIDownloadCache sharedCache] cachedResponseHeadersForURL:[self url]];
	if (!headers) {
		return NO;
	}
	NSString *dataPath = [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[self url]];
	if (!dataPath) {
		return NO;
	}
  return YES;
}


- (void)doneLoadingMoreDataFromNetwork:(ASIHTTPRequest *) _request {  
  NSString *json_string = _request.responseString;
  NSLog(@"%@",json_string);
  [self.responseData mergeNewresponseData:json_string];
  [self reload];
}


- (void)doneLoadingTableViewDataFromNetwork:(ASIHTTPRequest *) _request {
	if ([_request responseStatusCode] >= 400) {
    [self networkLoadDidFail:_request];
    return;
  }
  NSString *json_string = _request.responseString;
  PBAPIresponse *resp = [[PBAPIresponse alloc] initWithresponseData:_request.responseString];
  self.responseData = resp;
  [resp release];
  
  SBJSON *parser = [[SBJSON alloc] init];
  self.data = [parser objectWithString:json_string error:nil];
  [parser release];
  
  
  loadMoreDataURL = [NSURL URLWithString: [[[(NSDictionary *)self.data objectForKey:@"response"] objectForKey:@"posts"] objectForKey:@"next"]];
  [loadMoreDataURL retain];
  /* 
   if ([[data class] isSubclassOfClass:[NSDictionary class]]) {
   if ([data objectForKey:@"user"]) {
   if ([[data objectForKey:@"user"] objectForKey:@"more_photos_url"]) {
   loadMoreDataURL = [[data objectForKey:@"user"] objectForKey:@"more_photos_url"];
   }
   }
   }
   */ 
  
  [self reload];
  
	[self dataSourceDidFinishLoadingNewData];
}

- (void)networkLoadDidFail:(ASIHTTPRequest *) request {  
  if (!errorHud) {
    errorHud = [[PBProgressHUD alloc] initWithView:self.tableView];
    [errorHud retain];
  }
  [self.view addSubview:errorHud];
  errorHud.labelText = @"Error";
  [errorHud showUsingAnimation:YES];
  
  [errorHud performSelector:@selector(hideUsingAnimation:) withObject:self afterDelay:2.0];
  // UIAlertView *a = [[UIAlertView alloc] initWithTitle:nil message:@"Error" delegate:nil cancelButtonTitle:@"k" otherButtonTitles:nil];
  // [a show];
  // [a release];
  
	[self dataSourceDidFinishLoadingNewData];
}

- (void)reloadTableViewDataSourceUsingCache:(BOOL)useCache {
  if (!self.baseURL) {
    NSLog(@"Error: url not set");
    [self doneLoadingTableViewDataFromNetwork:nil];
    return;
  }
  
  NSString *authToken = [(AppDelegate *)[[UIApplication sharedApplication] delegate] authToken];
  
  
  ASICachePolicy cachePolicy = useCache?ASIOnlyLoadIfNotCachedCachePolicy:ASIDoNotReadFromCacheCachePolicy;
  
  request = [ASIHTTPRequest requestWithURL:[self url]
                                usingCache:useCache?[ASIDownloadCache sharedCache]:nil
                            andCachePolicy:cachePolicy];
  [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
  if (authToken) {
    //THE 'X' IN THE PASSWORD IS NEEDED TO FORCE THE NETWORKING LIBRARY TO ADDD
    //THE AUTH TOKEN.  THE SERVER SIDE, (DEVISE) IGNORES IT
    [request setUsername:authToken];
    [request setPassword:@"X"]; 
  }
  [request addRequestHeader:@"Accept" value:@"application/json"];
  
  [request setTimeOutSeconds:60];
  [request setUseCookiePersistence:NO];
  [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(doneLoadingTableViewDataFromNetwork:)];
  [request setDidFailSelector:@selector(networkLoadDidFail:)];
  
  [request startAsynchronous];
}

- (void)loadMoreFromNetwork {
  NSLog(@"\n");
  loadMoreDataURL = [self.responseData loadMoreDataURL];
  NSLog(@"Loading More: %@",loadMoreDataURL);
  if (!loadMoreDataURL) {
    NSLog(@"Error: load more url not set");
    //[self doneLoadingTableViewDataFromNetwork:nil];
    return;
  }
  
  
  
  request = [ASIHTTPRequest requestWithURL:loadMoreDataURL
                                usingCache:[ASIDownloadCache sharedCache]
                            andCachePolicy:ASIUseDefaultCachePolicy];
  [request setTimeOutSeconds:60];
  [request setUseCookiePersistence:NO];
  [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(doneLoadingMoreDataFromNetwork:)];
  [request startAsynchronous];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	loadingView.center = CGPointMake(self.view.center.x, self.view.center.y + scrollView.contentOffset.y);

  
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == PBPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:PBPullRefreshNormal];
		} else if (refreshHeaderView.state == PBPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:PBPullRefreshPulling];
		}
    if (scrollView.contentOffset.y < 0.0f) {
      if (scrollView.contentOffset.y >= -65.0) {
        [refreshHeaderView.circle setProgress:scrollView.contentOffset.y/-65.0];
      }
      else {
        [refreshHeaderView.circle setProgress:1.0f];
      }
      
    }
  }
}

- (void) enterReloadMode {
  _reloading = YES;
  [self reloadTableViewDataSourceUsingCache:NO];
  [refreshHeaderView setState:PBPullRefreshLoading];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
  [UIView commitAnimations];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (self.pullsToRefresh) {
    if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
      [self enterReloadMode];
    }
  }
}

-(void) showLoadingIndicator {
  if (!loadingView) {
    loadingView = [[PBProgressHUD alloc] initWithView:self.view];
    [loadingView setLabelText:@"Loading..."];
    
  }
  [self.view addSubview:loadingView];
  [loadingView showUsingAnimation:YES];

}

-(void) hideLoadingIndicator {
  [loadingView hide:YES];
}

-(void) loadDataFromCacheIfAvailable {
  if (!self.url) {
    return;
  }
  
  if ([self cachedDataAvailable]) {
    [self reloadTableViewDataSourceUsingCache:YES];
  }
  else {
    [self showLoadingIndicator];
    [self reloadTableViewDataSourceUsingCache:NO];     
  }
}

- (void)dataSourceDidFinishLoadingNewData {
	_reloading = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
  [self hideLoadingIndicator];
	[UIView commitAnimations];
	[refreshHeaderView setState:PBPullRefreshNormal];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
   [loadMoreDataURL release];
  // [request cancel];
  // [request release];
	refreshHeaderView = nil;
  [super dealloc];
}

-(void) reload {
  [self hideLoadingIndicator];
  [self.tableView reloadData];
}
@end

