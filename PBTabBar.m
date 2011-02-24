//
//  PBTabBar.m
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBTabBar.h"

@implementation PBTabBar

-(void) addCustomBackground {
  if (!cameraButton){
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *up = [UIImage imageNamed:@"btn_camera_up.png"];
    cameraButton.frame = CGRectMake((self.bounds.size.width/2) - (up.size.width/2), 
                                    self.bounds.origin.y-(up.size.height - self.frame.size.height), 
                                    up.size.width, 
                                    up.size.height);
    [cameraButton setImage:up forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"btn_camera_over.png"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:[[UIApplication sharedApplication] delegate] action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
  }
}

-(void) layoutSubviews {
  [self addCustomBackground];
}


@end
