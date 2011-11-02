//
//  PBNavigationController.m
//  PicBounce2
//
//  Created by Brad Smith on 01/11/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBNavigationController.h"
#import "Utilities.h"

@implementation UINavigationBar (BackgroundImage)

- (void)biInsertSubview:(UIView *)view atIndex:(NSInteger)index {
  [self biInsertSubview:view atIndex:index];
	
  UIView *backgroundImageView = [self viewWithTag:kNavBarImageTag];
  if (backgroundImageView != nil) {
    [self biInsertSubview:backgroundImageView atIndex:1];
  }
}

- (void)biSendSubviewToBack:(UIView *)view {
  [self biSendSubviewToBack:view];
	
  UIView *backgroundImageView = [self viewWithTag:kNavBarImageTag];
  if (backgroundImageView != nil) {
    [self biInsertSubview:backgroundImageView atIndex:1];
  }
}

@end


@implementation PBNavigationController

-(void) customizeNavBar {
  UINavigationBar *navBar = [self navigationBar];
   navBar.tintColor = kNavBarColor;
   
   UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kNavBarImageTag];
   if (imageView == nil) {
   imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_navbar.png"]];
   [imageView setTag:kNavBarImageTag];
   [navBar insertSubview:imageView atIndex:1];
   [imageView release];
   }
}

-(void) viewDidLoad {
  [super viewDidLoad];
  [self customizeNavBar];
  self.delegate = self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
  if (self = [super initWithRootViewController:rootViewController]) {
    [self customizeNavBar];
    self.delegate = self;
  }
  return self;
}




// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
}

@end
