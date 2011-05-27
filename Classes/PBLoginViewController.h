//
//  PBLoginViewController.h
//  PicBounce2
//
//  Created by Brad Smith on 5/23/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBLoginViewController : UIViewController {
  UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;


-(IBAction) submitButtonPressed:(id)sender;
-(IBAction) facebookButtonPressed:(id)sender;
-(IBAction) twitterButtonPressed:(id)sender;

@end
