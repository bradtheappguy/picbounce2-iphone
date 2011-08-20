//
//  PBCameraViewController.h
//  PicBounce2
//
//  Created by Brad Smith on 7/5/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FlashButton.h"

@interface PBCameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
  
  IBOutlet UIView *previewView;
	IBOutlet UISegmentedControl *camerasControl;
	AVCaptureVideoPreviewLayer *previewLayer;
	AVCaptureVideoDataOutput *videoDataOutput;
	BOOL detectFaces;
	dispatch_queue_t videoDataOutputQueue;
  AVCaptureSession *session;
	AVCaptureStillImageOutput *stillImageOutput;
	UIImageView *flashView;
	UIImage *mustache;
	BOOL isUsingFrontFacingCamera;
	CIDetector *faceDetector;
	CGFloat beginGestureScale;
	CGFloat effectiveScale;
  AVCaptureDeviceInput *deviceInput;
  
  
  FlashButton *flashButton;
  UIButton *flipButton;
  UIButton *HDRButton;
  UIButton *filterButton;
  UIButton *shareButton;
  UIButton *doneButton;
  UIButton *cancelButton;
  
  UIImageView *toolBar;
  UIButton *cameraButton;
  UIView *history;
  
  dispatch_queue_t queue;
  
  UIImageView *cameraStill;

  IBOutlet UIButton *facebookButton;
  IBOutlet UIButton *twitterButton;
  IBOutlet UIButton *tubmlerButton;
  IBOutlet UIButton *flickrButton;
  IBOutlet UIButton *posteriousButton;
  IBOutlet UIButton *myspaceButton;
  
  IBOutlet UIScrollView *filterScrollView;
  
  IBOutlet UIView *cameraToolbar;
  
  IBOutlet UIImageView *uploadPreviewImage;
}

-(IBAction) cameraButtonPressed:(id)sender;
-(IBAction) closeButtonPressed:(id)sender;
-(IBAction) optionsButtonPressed:(id)sender;
-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) uploadButtonPressed:(id)sender;
-(IBAction) retakeButtonPressed:(id)sender;
@end
