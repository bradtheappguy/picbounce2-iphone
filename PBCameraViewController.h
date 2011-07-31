//
//  PBCameraViewController.h
//  PicBounce2
//
//  Created by Brad Smith on 7/5/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaptureSessionManager.h"

@interface PBCameraViewController : UIViewController {
  UIButton *flashButton;
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
  
  
  IBOutlet UIButton *facebookButton;
  IBOutlet UIButton *twitterButton;
  IBOutlet UIButton *tubmlerButton;
  IBOutlet UIButton *flickrButton;
  IBOutlet UIButton *posteriousButton;
  IBOutlet UIButton *myspaceButton;
  
  IBOutlet UIScrollView *filterScrollView;
}

-(IBAction) cameraButtonPressed:(id)sender;
-(IBAction) optionsButtonPressed:(id)sender;
-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) uploadButtonPressed:(id)sender;
-(IBAction) retakeButtonPressed:(id)sender;
@end
