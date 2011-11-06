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
    [self biInsertSubview:backgroundImageView atIndex:0];
  }
}

- (void)biSendSubviewToBack:(UIView *)view {
  [self biSendSubviewToBack:view];
	
  UIView *backgroundImageView = [self viewWithTag:kNavBarImageTag];
  if (backgroundImageView != nil) {
    [self biInsertSubview:backgroundImageView atIndex:0];
  }
}

@end


@implementation PBNavigationController
@synthesize style;

-(void) customizeNavBar {
  [self setStyle:style];
}

-(void) setStyle:(NSUInteger)_style {
  UINavigationBar *navBar = [self navigationBar];
  UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kNavBarImageTag];
  
  if ((style == _style) && (imageView != nil)) {
    return;
  }
  style = _style;
  [[navBar viewWithTag:kNavBarImageTag] removeFromSuperview];
  if (style == 1) {
    navBar.tintColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_navbar_black.png"]];
    [imageView setTag:kNavBarImageTag];
    [navBar insertSubview:imageView atIndex:1];
    [imageView release];
    
  }
  else {
    navBar.tintColor = kNavBarColor;
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
    //[self customizeNavBar];
    //self.delegate = self;
  }
  return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController style:(NSUInteger)style {
  if (self = [super initWithRootViewController:rootViewController]) {
    self.style = 1;
  }
  return self;
}


// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
}

@end
