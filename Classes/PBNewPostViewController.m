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
#import "PBNavigationBarButtonItem.h"

@implementation PBNewPostViewController
@synthesize takePhotoButton;
@synthesize previewImageView;
//--------synthesize UIView
@synthesize inputAccView;

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
    //---set deleagate of UITextView
     postTextView.delegate=self;
    
    
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
    
  
  [self setTitle:@"New Post"];
  self.navigationItem.rightBarButtonItem = [PBNavigationBarButtonItem itemWithTitle:@"Post" target:self action:@selector(postButtonPressed:)];
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
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] switchToProfileTabPopToRootAndScrollToTop];
  
  
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

-(void) setTitle:(NSString *)title {
  [super setTitle:title];
  UILabel *l = (UILabel *)self.navigationItem.titleView;
  
  if ([l.text isEqualToString:self.navigationItem.title] == NO) {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    label.shadowColor = [UIColor colorWithRedInt:148 greenInt:148 blueInt:148 alphaInt:128];
    label.shadowOffset = CGSizeMake(-1, 1);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = kNavBarDarkTitleTextColor
    
    label.text = self.navigationItem.title;
    [label sizeToFit];
    self.navigationItem.titleView = label;
  }
}

#pragma for done button of textView

//---implement method for toolbar with button on keyboard

-(void)createInputAccessoryView{
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    
    UIToolbar *Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    [Toolbar sizeToFit];
    Toolbar.barStyle = UIBarStyleBlack;
    Toolbar.tintColor = [UIColor darkGrayColor];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneTyping)];  
    [barItems addObject:doneButton];
    
    [Toolbar setItems:barItems animated:YES];
    [inputAccView addSubview:Toolbar];
    
}

-(void)doneTyping{
    
    [postTextView resignFirstResponder];
    self.navigationItem.rightBarButtonItem.enabled=YES;
}


//TextView delegate method 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.navigationItem.rightBarButtonItem.enabled=NO;
    return  YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    [self createInputAccessoryView];
    [postTextView setInputAccessoryView:inputAccView];
    postTextView = textView; 
    return YES;
}



@end
