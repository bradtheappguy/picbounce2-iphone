#import "RootViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIDownloadCache.h"

@interface RootViewController (Private)

- (void)dataSourceDidFinishLoadingNewData;

@end


@implementation RootViewController

@synthesize reloading=_reloading, url;

- (void)viewDidLoad {
  [super viewDidLoad];
	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
		[self.tableView addSubview:refreshHeaderView];
		self.tableView.showsVerticalScrollIndicator = YES;
		[refreshHeaderView release];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
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

- (void)doneLoadingTableViewDataFromNetwork:(ASIHTTPRequest *) request {
	NSString *json_string = request.responseString;
	NSArray *array = [[[SBJSON alloc] init] objectWithString:json_string error:nil];
  
  NSLog(@"%@",json_string);
  data = [array retain];
  [self.tableView reloadData];
  
	[self dataSourceDidFinishLoadingNewData];
}

- (void)reloadTableViewDataSourceUsingCache:(BOOL)useCache {
  if (!self.url) {
    NSLog(@"Error: url not set");
    [self doneLoadingTableViewDataFromNetwork:nil];
    return;
  }
  
  ASICachePolicy cachePolicy = useCache?ASIOnlyLoadIfNotCachedCachePolicy:ASIDoNotReadFromCacheCachePolicy;

  request = [ASIHTTPRequest requestWithURL:self.url
                                                usingCache:[ASIDownloadCache sharedCache]
                                            andCachePolicy:cachePolicy];
  [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(doneLoadingTableViewDataFromNetwork:)];
  [request startAsynchronous];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void) enterReloadMode {
  _reloading = YES;
  [self reloadTableViewDataSourceUsingCache:NO];
  [refreshHeaderView setState:EGOOPullRefreshLoading];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
  [UIView commitAnimations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
    [self enterReloadMode];
  }
}


-(void) loadDataFromCacheIfAvailable {
  if ([self cachedDataAvailable]) {
    [self reloadTableViewDataSourceUsingCache:YES];
  }
  else {
    [self enterReloadMode];      
  }
}

- (void)dataSourceDidFinishLoadingNewData{
	
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	[refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
  [request cancel];
  [request release];
	refreshHeaderView = nil;
  [super dealloc];
}


@end

