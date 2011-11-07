//
//  PBTabBar.m
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBTabBar.h"
#import "AppDelegate.h"

static const NSUInteger kNumberOfTabs = 3;
static  NSString *selectedIndex = @"selectedIndex";

@implementation PBTabBar

-(UITabBarController *) tabBarController {
  UITabBarController *tabBarController = (UITabBarController *)self.delegate;
  return tabBarController;
}

-(void) registerObservers {
  [[self tabBarController] addObserver:self forKeyPath:selectedIndex options:NSKeyValueChangeSetting context:nil];
}


-(id) initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self registerObservers];
  }
  return self;
}

-(id) initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self registerObservers];
  }
  return self;
}

-(void) dealloc {
  [[self tabBarController] removeObserver:self forKeyPath:selectedIndex];
  [feedTabButton release];
  [cameraButton release];
  [profileTabButton release];
  [super dealloc];
}

-(UIButton *)buttonForIndex:(NSUInteger)index 
       withNormalImageNamed:(NSString *)normalImageName 
         selectedImageNamed:(NSString *)selectedImageNamed {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.adjustsImageWhenHighlighted = NO;
  [button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
  //[button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateHighlighted];
  [button setBackgroundImage:[UIImage imageNamed:selectedImageNamed] forState:UIControlStateSelected];
  button.frame = CGRectMake((self.bounds.size.width/kNumberOfTabs*index), 
                            0-2,
                            self.bounds.size.width/kNumberOfTabs,
                            self.bounds.size.height+2);
  [button addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
  UIGestureRecognizer *longTouchRecognier = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonWasLongPressed:)];
  [button addGestureRecognizer:longTouchRecognier];
  [longTouchRecognier release];
  
  button.tag = index;
  return button;
}

-(void) setSelectedButton:(UIButton *)button {
  if (selectedButton == button) {
    return;
  }
  [selectedButton setSelected:NO];
  [[selectedButton viewWithTag:1] setAlpha:0.25];
  [selectedButton setBackgroundImage:[selectedButton backgroundImageForState:UIControlStateNormal] forState:UIControlStateHighlighted];
  selectedButton = button;
  [selectedButton setSelected:YES];
  [[selectedButton viewWithTag:1] setAlpha:1.0];
  [selectedButton setBackgroundImage:[selectedButton backgroundImageForState:UIControlStateSelected] forState:UIControlStateHighlighted];
}


-(void) updateSelectedButton {
  UITabBarController *tabBarController = (UITabBarController *)self.delegate;
  NSUInteger index = tabBarController.selectedIndex;
  if (index == 0) {
    [self setSelectedButton:feedTabButton];
  }
  if (index == 2) {
    [self setSelectedButton:profileTabButton];
  }
}

-(UILabel *)labelForButtonWithTitle:(NSString *)title {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(33, feedTabButton.bounds.size.height-15, 61, 10)];
  label.backgroundColor = [UIColor clearColor];
  label.text = title;
  label.alpha = 0.25;
  label.font = [UIFont boldSystemFontOfSize:10];
  label.textColor = kNavBarTitleTextColor
  label.textAlignment = UITextAlignmentCenter;
  label.tag = 1;
  return [label autorelease];
}

-(void) customize {
  self.clipsToBounds = NO;
  if (!feedTabButton) {
    feedTabButton = [self buttonForIndex:0 withNormalImageNamed:@"btn_feed_n" selectedImageNamed:@"btn_feed_s"];
    [feedTabButton addSubview:[self labelForButtonWithTitle:@"Feed"]];
  }
  [self addSubview:feedTabButton];
  if (!cameraButton) {
    cameraButton = [self buttonForIndex:1 withNormalImageNamed:@"btn_camera_n" selectedImageNamed:@"btn_camera_s"];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_h"] forState:UIControlStateHighlighted];
  }
  [self addSubview:cameraButton];
  if (!profileTabButton) {
    profileTabButton = [self buttonForIndex:2 withNormalImageNamed:@"btn_profile_n" selectedImageNamed:@"btn_profile_s"];
    UILabel *l = [self labelForButtonWithTitle:@"Profile"];
    [profileTabButton addSubview:l];
    l.center = CGPointMake(l.center.x-23, l.center.y);
  }
  [self addSubview:profileTabButton];
  if (!selectedButton) {
    [self updateSelectedButton];
  }
}



-(void) buttonWasPressed:(UIButton *)sender {
  UITabBarController *tabBarController = (UITabBarController *)self.delegate;
  if (sender == cameraButton) {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] cameraButtonPressed:sender];
  }
  else  {
    //[self setSelectedButton:sender];
    [tabBarController setSelectedIndex:sender.tag];
  }
}


-(void) buttonWasLongPressed:(UIGestureRecognizer *)longPressGestureRecoginer {
  [self buttonWasPressed:(UIButton *)longPressGestureRecoginer.view];
}


-(void) layoutSubviews {
  [self customize];
}


-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:selectedIndex]) {
    [self updateSelectedButton];
  }
}

@end