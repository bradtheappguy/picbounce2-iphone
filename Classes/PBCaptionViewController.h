//
//  PBCaptionViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 29/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "PBNavigationBar.h"
#import "ModalDismissDelegate.h"


@interface PBCaptionViewController : UIViewController < UITextViewDelegate, FBSessionDelegate, FBDialogDelegate >{
  IBOutlet UITextView *a_PostTextView;
  Facebook *_facebook;
  IBOutlet UIView *optionButtonView;
  IBOutlet PBNavigationBar *navBar;
  id<ModalDismissDelegate> delegate;
  
}
@property (nonatomic, assign) BOOL isCaptionView;
@property (nonatomic, assign) id<ModalDismissDelegate> delegate;
- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)twitterButtonClicked:(id)sender;
- (IBAction)optionButtonClicked:(id)sender;
- (IBAction)dismissModalViewControllerAnimated;
@end
