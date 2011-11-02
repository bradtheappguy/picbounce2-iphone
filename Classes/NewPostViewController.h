//
//  NewPostViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "PBNavigationBar.h"
#import "TwitterButton.h"

@interface NewPostViewController : UIViewController < UITextViewDelegate, FBSessionDelegate, FBDialogDelegate >{
    IBOutlet UITextView *a_PostTextView;
    Facebook *_facebook;
    IBOutlet UIView *optionButtonView;
    IBOutlet PBNavigationBar *navBar;
  TwitterButton *a_TwitterButton;
}

@property (nonatomic, assign) BOOL isCaptionView;
- (IBAction)optionButtonClicked:(id)sender;
- (IBAction)dismissModalViewControllerAnimated;
@end
