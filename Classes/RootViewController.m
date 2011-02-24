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


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}
 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	refreshHeaderView=nil;
}


#pragma mark Table view methods


- (void)reloadTableViewDataSource {
  if (!self.url) {
    NSLog(@"Error: url not set");
    [self doneLoadingTableViewDataFromNetwork:nil];
    return;
  }
  request = [ASIHTTPRequest requestWithURL:self.url
                                                usingCache:[ASIDownloadCache sharedCache]
                                            andCachePolicy:ASIDoNotReadFromCacheCachePolicy];
  [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(doneLoadingTableViewDataFromNetwork:)];
  [request startAsynchronous];
  
	//  should be calling your tableviews model to reload
	//  put here just for demo
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (void)doneLoadingTableViewDataFromNetwork:(ASIHTTPRequest *) request {
	NSString *json_string = request.responseString;
	NSArray *array = [[[SBJSON alloc] init] objectWithString:json_string error:nil];
  
  NSLog(@"%@",json_string);
  data = [array retain];
  [self.tableView reloadData];
  
	[self dataSourceDidFinishLoadingNewData];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
    [self enterReloadMode];
  }
}

- (void) enterReloadMode {
  _reloading = YES;
  [self reloadTableViewDataSource];
  [refreshHeaderView setState:EGOOPullRefreshLoading];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
  [UIView commitAnimations];
  
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

