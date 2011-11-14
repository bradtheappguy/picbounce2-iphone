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
#import "ModalDismissDelegate.h"
#import "FacebookButton.h"
#import "FBConnect.h"


@interface PBCameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ModalDismissDelegate> {
  
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
  
  UIImage *unfilteredImage;
  
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

  IBOutlet UIScrollView *filterScrollView;
  
  IBOutlet UIView *cameraToolbar;
  
  IBOutlet UIImageView *uploadPreviewImage;
  //------ Implement indicater view --------------  
  IBOutlet UIActivityIndicatorView *filterProgressIndicator;
}

@property (nonatomic, retain)  UIImage *unfilteredImage;
//------ Implement indicater view --------------
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *filterProgressIndicator;
-(IBAction) photoLibraryButtonPressed:(id)sender;
-(IBAction) cameraButtonPressed:(id)sender;
-(IBAction) closeButtonPressed:(id)sender;
-(IBAction) optionsButtonPressed:(id)sender;
-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) uploadButtonPressed:(id)sender;
-(IBAction) retakeButtonPressed:(id)sender;
-(IBAction) captionButtonPressed:(id)sender;
-(IBAction) facebookButtonClicked:(id)sender;
-(IBAction) twitterButtonClicked:(id)sender;

- (BOOL) hasFlash;
- (void) imageFilterController:(NSString *)tag;

@end

UIImage *scaleAndRotateImage(UIImage *image);