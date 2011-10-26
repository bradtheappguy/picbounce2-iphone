//
//  NewPostViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface NewPostViewController : UIViewController < UITextViewDelegate, FBSessionDelegate, FBDialogDelegate >{
    IBOutlet UITextView *a_PostTextView;
    Facebook *_facebook;
}
- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)twitterButtonClicked:(id)sender;
- (IBAction)optionButtonClicked:(id)sender;
@end
