#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "PBAPIResponse.h"
#import "PBProgressHUD.h"


@class PBRefreshTableHeaderView, PBProgressHUD;



@interface PBRootViewController : UITableViewController {
	PBRefreshTableHeaderView *refreshHeaderView;
	
	//  Reloading should really be your tableviews model class
	//  Putting it here for demo purposes 
	BOOL _reloading;
  
  PBProgressHUD *errorHud;
  NSURL *loadMoreDataURL;
  PBProgressHUD *loadingView;
  ASIHTTPRequest *request;
}

- (void)networkLoadDidFail:(ASIHTTPRequest *) request;
- (void)reloadTableViewDataSourceUsingCache:(BOOL)useCache;
- (void) loadDataFromCacheIfAvailable;
- (void) dataSourceDidFinishLoadingNewData;
- (void) loadMoreFromNetwork;
- (NSURL *) url;
- (void) reload;

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) PBAPIresponse *responseData;
@property(nonatomic, retain)  NSString *baseURL;
@property(assign,getter=isReloading) BOOL reloading;
@property(readwrite) BOOL pullsToRefresh;
@end
