//
//  NewPostViewController.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBNewPostViewController.h"
#import "AppDelegate.h"
#import "PBSharingOptionViewController.h"
#import "PBAuthWebViewController.h"
#import "FacebookSingleton.h"
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "TwitterButton.h"
#import "FacebookButton.h"
#import "PBUploadQueue.h"
#import "PBNavigationController.h"

@implementation PBNewPostViewController
@synthesize isCaptionView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}


- (void)dealloc {
  [super dealloc];  
}


- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  if (isCaptionView) {
    optionButtonView.hidden = YES;
    CGRect frame = postTextView.frame;
    frame.size.height += 45;
    postTextView.frame = frame;
    postTextView.returnKeyType = UIReturnKeyDone;
  }else {
    FacebookButton *a_FacebookButton = [[FacebookButton alloc] initWithPosition:CGPointMake(117, 164)];
    [a_FacebookButton setText:@"Market Edition"];
    
    a_FacebookButton.selected = YES;//[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
    [a_FacebookButton addTarget:self action:@selector(facebookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:a_FacebookButton];
    [self.view bringSubviewToFront:a_FacebookButton];
    [a_FacebookButton release];
    
    twitterButton = [[TwitterButton alloc] initWithPosition:CGPointMake(79, 164)];
    
    
    twitterButton.selected = YES;//[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
    [twitterButton addTarget:self action:@selector(twitterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];
    [self.view bringSubviewToFront:twitterButton];
    [twitterButton release];
    
  }
  [postTextView becomeFirstResponder];
}


- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark CustomNavigationBar Methods
- (IBAction)dismissModalViewControllerAnimated {
	[self dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark Button Click Function


- (IBAction)optionsButtonPressed:(id)sender {
  PBSharingOptionViewController *vc = [[PBSharingOptionViewController alloc] initWithNibName:@"PBSharingOptionViewController" bundle:nil];
  PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:vc style:1];
  UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
  vc.navigationItem.leftBarButtonItem = cancel;
  [cancel release];
  [self presentModalViewController:nav animated:YES];
  [vc release];
  [nav release];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {  
  BOOL shouldChangeText = YES;  
  
  if ([text isEqualToString:@"\n"]) {  
    [self performSelector:@selector(postOnServer) withObject:nil afterDelay:0.01];
    shouldChangeText = NO;  
  }  
  return shouldChangeText;  
} 


#pragma mark New Post Upload to Facebook 
- (IBAction)facebookButtonClicked:(id)sender {
  
}


#pragma mark New Post Upload to Twitter 
- (IBAction)twitterButtonClicked:(id)sender {
  
}


#pragma mark New Post Upload to Server 
- (void)postOnServer {
  [[PBUploadQueue sharedQueue] uploadText:postTextView.text 
                    crossPostingToTwitter:twitterButton.selected 
                   crossPostingToFacebook:NO];
  [[(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarController] setSelectedIndex:2];
  [self dismissModalViewControllerAnimated:YES];
}



#pragma mark Facebbok Session Delegate
- (void)fbDidLogin {
  [postTextView resignFirstResponder];  
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/likes?limit=30&access_token=%@",_facebook.accessToken]];

	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0]autorelease];
	NSURLResponse *returnedResponse = nil;
	NSError *returnedError = nil;
	NSData *itemData  = [NSURLConnection sendSynchronousRequest:request returningResponse:&returnedResponse error:&returnedError];
	NSString* theString = [[NSString alloc] initWithData:itemData encoding:NSASCIIStringEncoding];
  NSMutableArray *array = [theString JSONValue];
}


-(void) followingRequestDidFail:(ASIHTTPRequest *)followingRequest {
  
}



-(void) followingRequestDidFinish:(ASIHTTPRequest *)followingRequest {
  
}


- (void)dialogDidComplete:(FBDialog*)dialog{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deal Shared!" message:@"You've successfully shared this deal on Facebook!"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


-(void) picbounceTokenRequestDidFail:(id) sender {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"FAiled to retrieve picbounce token" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
  
}


-(void) request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)url {
  
}


-(void) requestDidFinish:(ASIHTTPRequest *)request{
  //TODO
}


- (void)fbDidNotLogin:(BOOL)cancelled {
  
}


- (void)fbDidLogout {
  
}


@end
