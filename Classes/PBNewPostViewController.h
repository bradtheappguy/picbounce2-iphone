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
#import "FacebookButton.h"

@interface PBNewPostViewController : UIViewController < UITextViewDelegate, FBSessionDelegate, FBDialogDelegate >{
  IBOutlet UITextView *postTextView;
  Facebook *_facebook;
  TwitterButton *twitterButton;
  FacebookButton *facebookButton;
   //---Implement UIView for done button on Keyboard 
     UIView *inputAccView;
}
//---Define property for UIView for done button on Keyboard 
@property (nonatomic, retain) UIView *inputAccView;

@property (retain, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (retain, nonatomic) IBOutlet UIImageView *previewImageView;

- (IBAction)optionsButtonPressed:(id)sender;
- (IBAction)dismissModalViewControllerAnimated;
@end
  