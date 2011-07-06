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
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  self.view.frame = CGRectMake(0, 0, 320, 480);
  
  toolBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_capture_tabbar"]];
  toolBar.frame = CGRectMake(0, 480-54, 320, 54);
  [self.view addSubview:toolBar];
  
  cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cameraButton setBackgroundImage:[UIImage imageNamed:@"btn_capture_n"] forState:UIControlStateNormal];
  [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  cameraButton.frame = CGRectMake(160-53, 5, 106, 44);
  [toolBar addSubview:cameraButton];
  
 /* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_capture_cancel_n"] forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  cancelButton.frame = CGRectMake(0, 0, 32, 33);
  cancelButton.center = toolBar.center;
  [toolBar addSubview:cancelButton];
  */
  
  
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  if (UIDeviceOrientationIsLandscape(orientation)) {
    NSLog(@" ");
  }
  else {
    NSLog(@" ");
  }
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
