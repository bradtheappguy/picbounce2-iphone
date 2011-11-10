//
//  NewPostViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "TwitterButton.h"

@interface PBNewPostViewController : UIViewController < UITextViewDelegate, FBSessionDelegate, FBDialogDelegate >{
  IBOutlet UITextView *postTextView;
  Facebook *_facebook;
  IBOutlet UIView *optionButtonView;
  TwitterButton *twitterButton;
}

- (IBAction)optionsButtonPressed:(id)sender;
- (IBAction)dismissModalViewControllerAnimated;
@end
