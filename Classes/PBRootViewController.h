#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "PBAPIResponce.h"

@class EGORefreshTableHeaderView;



@interface PBRootViewController : UITableViewController {
	EGORefreshTableHeaderView *refreshHeaderView;
	
	//  Reloading should really be your tableviews model class
	//  Putting it here for demo purposes 
	BOOL _reloading;
    NSMutableArray *data;
  
  

  
  NSURL *loadMoreDataURL;
  
  ASIHTTPRequest *request;
}

- (void) loadDataFromCacheIfAvailable;
- (void) dataSourceDidFinishLoadingNewData;
- (void) loadMoreFromNetwork;
- (NSURL *) url;
- (void) reload;

@property (nonatomic, retain) PBAPIResponce *responceData;
@property(nonatomic, retain)  NSString *baseURL;
@property(assign,getter=isReloading) BOOL reloading;

@end
