//
//  PBCaptionViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 29/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"


@interface PBCaptionViewController : UIViewController < UITextViewDelegate, FBSessionDelegate, FBDialogDelegate >{
    IBOutlet UITextView *a_PostTextView;
    Facebook *_facebook;
    IBOutlet UIView *optionButtonView;
    IBOutlet UINavigationBar *captionNavigationBar;
}
@property (nonatomic, assign) BOOL isCaptionView;
- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)twitterButtonClicked:(id)sender;
- (IBAction)optionButtonClicked:(id)sender;
- (IBAction)backBarButtonItemClicked ;
@end
