//
//  PathBoxesAppDelegate.h
//  PathBoxes
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBProfileViewController.h"

@interface PathBoxesAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UITabBarController *tabBarController;
  
  IBOutlet PBProfileViewController *feedViewController;
  IBOutlet PBProfileViewController *profileViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@end

