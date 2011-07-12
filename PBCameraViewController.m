//
//  PBCameraViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 7/5/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

//TODO extract Toolbar into class


#import "PBCameraViewController.h"
#import "FlashButton.h"

#define PREVIEW_FRAME

@implementation PBCameraViewController

-(void) viewDidLoad {
  self.wantsFullScreenLayout = YES;
  [super viewDidLoad];
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  self.view.frame = CGRectMake(0, 0, 320, 480);
  
  toolBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_capture_tabbar"]];
  toolBar.frame = CGRectMake(0, 480-55, 320, 55);
  toolBar.userInteractionEnabled = YES;
  [self.view addSubview:toolBar];
  
  CGRect x = {1,2,3,4};
  x = x;
  cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cameraButton setBackgroundImage:[UIImage imageNamed:@"btn_capture_n"] forState:UIControlStateNormal];
  [cameraButton setBackgroundImage:[UIImage imageNamed:@"btn_capture_s"] forState:UIControlStateSelected];
  [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  cameraButton.frame = CGRectMake(160-53, 5, 106, 44);
  [toolBar addSubview:cameraButton];
  
  cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_capture_cancel_n"] forState:UIControlStateNormal];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_capture_cancel_s"] forState:UIControlStateSelected];
  [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  cancelButton.frame = CGRectMake(320-32-5, 10, 32, 33);
  [toolBar addSubview:cancelButton];
    
  UIImageView *cropRect = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 850/2)];
  [cropRect setImage:[UIImage imageNamed:@"bg_photo_crop"]];
  [self.view addSubview:cropRect];
 
  flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [flipButton setBackgroundImage:[UIImage imageNamed:@"btn_flip_n"] forState:UIControlStateNormal];
  [flipButton addTarget:self action:@selector(flipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  flipButton.frame = CGRectMake(320-71-5, 5, 71, 37);
  [self.view addSubview:flipButton];
  
  flashButton = [FlashButton button];
   [flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:flashButton];
  
  HDRButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [HDRButton setBackgroundImage:[UIImage imageNamed:@"btn_hdr_n"] forState:UIControlStateNormal];
  [HDRButton addTarget:self action:@selector(hdrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  HDRButton.frame = CGRectMake((320/2) - (95/2), 5, 95, 37);
  [self.view addSubview:HDRButton];
  
  queue = dispatch_queue_create("com.picbounce.internalqueue", NULL);
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
  [[self.view layer] insertSublayer:previewLayer atIndex:0];
  
}

-(void) cameraButtonPressed:(id)sender {
  [[CaptureSessionManager sharedManager] capturePhotoWithCompletionHandler:
   ^(CMSampleBufferRef ref, NSError *error) {
     dispatch_async(queue, ^(void) {
       sleep(5);
       NSLog(@"I took a photo.");  
     });
   }];
  
}

-(void) cancelButtonPressed:(id)sender {
  [self dismissModalViewControllerAnimated:NO];
}

-(void) flashButtonPressed:(id)sender {
  
}

-(void) flipButtonPressed:(id)sender {
  BOOL x = [[CaptureSessionManager sharedManager] flip];
  x = x;
}

-(void) hdrButtonPressed:(id)sender {
  
}

-(void) dealloc {
  [super dealloc];
  dispatch_release(queue);
}

@end
