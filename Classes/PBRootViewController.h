#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "PBAPIResponce.h"

@class PBRefreshTableHeaderView, MBProgressHUD;



@interface PBRootViewController : UITableViewController {
	PBRefreshTableHeaderView *refreshHeaderView;
	
	//  Reloading should really be your tableviews model class
	//  Putting it here for demo purposes 
	BOOL _reloading;
  
  MBProgressHUD *errorHud;
  NSURL *loadMoreDataURL;
  
  ASIHTTPRequest *request;
}

- (void)reloadTableViewDataSourceUsingCache:(BOOL)useCache;
- (void) loadDataFromCacheIfAvailable;
- (void) dataSourceDidFinishLoadingNewData;
- (void) loadMoreFromNetwork;
- (NSURL *) url;
- (void) reload;

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) PBAPIResponce *responceData;
@property(nonatomic, retain)  NSString *baseURL;
@property(assign,getter=isReloading) BOOL reloading;
@property(readwrite) BOOL pullsToRefresh;
@end
