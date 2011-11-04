//
//  PBCaptionViewController.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 29/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBCaptionViewController.h"
#import "PBNewPostViewController.h"
#import "PBSharingOptionViewController.h"
#import "PBAuthWebViewController.h"
#import "FacebookSingleton.h"
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "SBJSON.h"
#import "NSString+SBJSON.h"

#import "TwitterButton.h"
#import "FacebookButton.h"
@implementation PBCaptionViewController
@synthesize isCaptionView;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [super dealloc];  
}
- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
        // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    
    
        
   
    
    
    
    [a_PostTextView becomeFirstResponder];
        //https://graph.facebook.com/fql?q=select%20page_id,%20type,%20name,%20page_url,pic_small%20from%20page%20where%20page_id%20in%20%28%20select%20page_id,type%20from%20page_admin%20where%20uid=me%28%29%20and%20type=%27WEBSITE%27%29?access_token=ACCESS_TOKEN_FROM_FACEBOOK
    
    
}


- (IBAction)backBarButtonItemClicked {
    [self dismissModalViewControllerAnimated:YES];
    [delegate didDismissModalView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark Button Click Function


- (IBAction)optionButtonClicked:(id)sender {
    
    PBSharingOptionViewController *vc = [[PBSharingOptionViewController alloc] initWithNibName:@"PBSharingOptionViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark -
#pragma mark CustomNavigationBar Methods

- (IBAction)dismissModalViewControllerAnimated {
	[self dismissModalViewControllerAnimated:YES];
  [delegate didDismissModalView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {  
    BOOL shouldChangeText = YES;  
    
    if ([text isEqualToString:@"\n"]) {  
            // Find the next entry field 
        [self performSelector:@selector(postOnServer) withObject:nil afterDelay:0.01];
        shouldChangeText = NO;  
    }  
    return shouldChangeText;  
}



#pragma mark New Post Upload to Server 
- (void)postOnServer {
    
}
@end
