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
  UIButton *HIDButton;
  UIButton *filterButton;
  UIButton *shareButton;
  UIButton *doneButton;
  UIButton *cancelButton;
  
  UIView *toolBar;
  UIButton *camceraButton;
  UIView *history;
}
@end
