//
//  PathBoxesAppDelegate.h
//  PathBoxes
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBStreamViewController.h"
#import "PBCameraViewController.h"

@interface PathBoxesAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UITabBarController *tabBarController;
  
  IBOutlet PBStreamViewController *feedViewController;
  IBOutlet PBStreamViewController *popularViewController;
  IBOutlet PBStreamViewController *liveViewController;
  IBOutlet PBStreamViewController *profileViewController;
  
  IBOutlet PBCameraViewController *cameraViewController;
}

@property (nonatomic, retain) IBOutlet NSString *authToken;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@end

