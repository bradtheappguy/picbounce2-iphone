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


  -(void) setStyle:(NSUInteger)style {
    UINavigationBar *navBar = self;
    UIImage *image;
    if ([navBar respondsToSelector:@selector(backgroundImageForBarMetrics:)]) {
      image = [navBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
    else {
      image = [(UIImageView *)[navBar viewWithTag:kNavBarImageTag] image];
    }
    
    if ((image != nil)) {
      return;
    }

    [[navBar viewWithTag:kNavBarImageTag] removeFromSuperview];
    if (style == 1) {
      navBar.tintColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1];
      
      if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar_black.png"] forBarMetrics:UIBarMetricsDefault];
      }
      else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_navbar_black.png"]];
        [imageView setTag:kNavBarImageTag];
        [navBar insertSubview:imageView atIndex:1];
        [imageView release];
      }
    }
    else {
      if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar.png"] forBarMetrics:UIBarMetricsDefault];
      }
      else {
        navBar.tintColor = kNavBarColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_navbar.png"]];
        [imageView setTag:kNavBarImageTag];
        [navBar insertSubview:imageView atIndex:1];
        [imageView release];
      }
    }
    
    
  }

@end


@implementation PBNavigationController
@synthesize style;

-(void) customizeNavBar {
  [[self navigationBar] setStyle:style];
}

-(void) viewDidLoad {
  [super viewDidLoad];
  [self customizeNavBar];
  self.delegate = self;
  self.view.backgroundColor = [UIColor blackColor];
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
