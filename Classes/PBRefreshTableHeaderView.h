#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CircleView.h"

typedef enum {
	PBPullRefreshPulling = 0,
	PBPullRefreshNormal,
	PBPullRefreshLoading,	
} PBPullRefreshState;


@interface PBRefreshTableHeaderView : UIView {	
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
	PBPullRefreshState _state;
}

@property(nonatomic, retain) CircleView *circle;
@property(nonatomic, readwrite) PBPullRefreshState state;

- (void)setState:(PBPullRefreshState)aState;

@end
