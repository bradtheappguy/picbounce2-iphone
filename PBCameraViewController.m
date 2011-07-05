//
//  PBCameraViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 7/5/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBCameraViewController.h"

#define PREVIEW_FRAME

@implementation PBCameraViewController

-(void) viewDidLoad {
  self.wantsFullScreenLayout = YES;
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 0, 320, 480);
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  [[self.tabBarController tabBar] setAlpha:0];
  
  CALayer *previewLayer = [[CaptureSessionManager sharedManager] previewLayer];
  //CGRect bounds = [previewLayer bounds];
  
  CGFloat width  = 320.0f;
  CGRect layerRect = CGRectMake(0, 0, width, 426);
  
  if ([[[CaptureSessionManager sharedManager] captureSession] isRunning] == NO) {
    [[[CaptureSessionManager sharedManager] captureSession] startRunning];  
  }
  [previewLayer setBounds:layerRect];
  [previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
  [(id)previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
  
  [(id)previewLayer setBackgroundColor:[UIColor redColor].CGColor];
  [[self.view layer] addSublayer:previewLayer];
  
}


@end
