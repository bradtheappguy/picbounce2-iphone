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
#import "PBUploadQueue.h"
#import "PBNavigationController.h"
#import "PBSharedUser.h"

@implementation PBNewPostViewController
@synthesize takePhotoButton;
@synthesize previewImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}


- (void)dealloc {
  [previewImageView release];
  [takePhotoButton release];
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
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_upload_screens"]];
    facebookButton = [[FacebookButton alloc] initWithPosition:CGPointMake(140, 164)];
    
    facebookButton.selected = YES;//[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookButton];
    [self.view bringSubviewToFront:facebookButton];
    [facebookButton release];
  
  
    twitterButton = [[TwitterButton alloc] initWithPosition:CGPointMake(79, 164)];
    
    
    twitterButton.selected = YES;//[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
    [twitterButton addTarget:self action:@selector(twitterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];
    [self.view bringSubviewToFront:twitterButton];
    [twitterButton release];
    
  
  
  UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonPressed:)];
  self.navigationItem.rightBarButtonItem = postButton;
  [postButton release];
}


- (void)viewDidUnload {
  [self setPreviewImageView:nil];
  [self setTakePhotoButton:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [self.navigationController setWantsFullScreenLayout:NO];
  self.wantsFullScreenLayout = NO;
  [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
  facebookButton.selected = [PBSharedUser shouldCrosspostToFB];
  twitterButton.selected = [PBSharedUser shouldCrosspostToTW];
  [postTextView becomeFirstResponder];
  if ([PBSharedUser facebookAccessToken]) {
    facebookButton.hidden = NO;
  }
  else {
    facebookButton.hidden = YES;
  }
}

-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
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
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}



#pragma mark New Post Upload to Facebook 
- (IBAction)facebookButtonClicked:(id)sender {
  
}


#pragma mark New Post Upload to Twitter 
- (IBAction)twitterButtonClicked:(id)sender {
  
}


#pragma mark New Post Upload to Server 
- (void)postButtonPressed:(id)sender {
  
  
  if (self.previewImageView.image) {
    [[PBUploadQueue sharedQueue] uploadText:postTextView.text  
                                  withImage:self.previewImageView.image 
                      crossPostingToTwitter:twitterButton.selected 
                     crossPostingToFacebook:facebookButton.selected];
  }
  else {
    [[PBUploadQueue sharedQueue] uploadText: postTextView.text 
                      crossPostingToTwitter: twitterButton.selected 
                     crossPostingToFacebook: facebookButton.selected];
  }
  [[(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarController] setSelectedIndex:2];
  
  
  [self dismissModalViewControllerAnimated:YES];
}



#pragma mark Facebbok Session Delegate
- (void)fbDidLogin {
  [postTextView resignFirstResponder];  
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

- (IBAction)takePhotoButtonPressed:(id)sender {
}

@end
