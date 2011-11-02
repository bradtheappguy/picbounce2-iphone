//
//  PicBounce2AppDelegate.h
//  PicBounce2
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBStreamViewController.h"
#import "PBCameraViewController.h"
#import "PBLoginViewController.h"
#import "FeedViewController.h"
@interface AppDelegate : NSObject <UIApplicationDelegate> {

  NSString *apnsToken;
  
  IBOutlet PBStreamViewController *feedViewController;
  IBOutlet PBStreamViewController *popularViewController;
  IBOutlet PBStreamViewController *liveViewController;
  IBOutlet PBStreamViewController *profileViewController;
  IBOutlet PBCameraViewController *cameraViewController;
  
  PBLoginViewController *loginViewController;

  BOOL usingCameraView;
}

@property (nonatomic, retain) IBOutlet NSString *authToken;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIViewController *currentController;

-(void) presentLoginViewController:(BOOL)useCameraViewController;

@end

