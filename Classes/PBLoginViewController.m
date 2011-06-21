//
//  PBLoginViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 5/23/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBLoginViewController.h"
#import "PBAuthWebViewController.h"
#import "FacebookSingleton.h"
#import "PathBoxesAppDelegate.h"
@implementation PBLoginViewController

@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize submitButton = _submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc {
  self.emailTextField = nil;
  self.passwordTextField = nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.emailTextField = nil;
  self.passwordTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Button Handeling
-(IBAction) submitButtonPressed:(id)sender {
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://smokey.picbounce.com/users/auth/picbounce"]];
  [request setRequestCookies:nil];
  [request setUsername:emailTextField.text];
  [request setPassword:passwordTextField.text];
  [request setDelegate:self];
  [request setDidFailSelector:@selector(loginRequestDidFail:)];
  [request setDidFinishSelector:@selector(loginRequestDidFinish:)];
  [request startAsynchronous];
}

-(void) loginRequestDidFail:(ASIHTTPRequest *)request {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"An Error Occured" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
}

-(void) loginRequestDidFinish:(ASIHTTPRequest *)request {
  int code = [request responseStatusCode];
  if (code > 200) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"Incorrect Username or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
}


-(IBAction) facebookButtonPressed:(id)sender {
  
  FacebookSingleton *_facebook = nil;
  
  BOOL isLoggedIn;
  
	if (_facebook == nil) {
		_facebook = [FacebookSingleton sharedFacebook];
		_facebook.sessionDelegate = self;
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
		NSDate *exp = [[NSUserDefaults standardUserDefaults] objectForKey:@"exp_date"];
		
		if (token != nil && exp != nil && [token length] > 2) {
			isLoggedIn = YES;
			_facebook.accessToken = token;
      _facebook.expirationDate = [NSDate distantFuture];
		} 
    
		[_facebook retain];
	}
	
  //if no session is available login
	[_facebook authorize:[NSArray arrayWithObject: @"publish_stream"] delegate:self];
}


-(IBAction) twitterButtonPressed:(id)sender {
  PBAuthWebViewController *viewController = [[PBAuthWebViewController alloc] initWithNibName:@"PBAuthWebViewController" bundle:nil];
  viewController.authenticationURLString = @"http://smokey.picbounce.com/users/auth/twitter";
  viewController.title = NSLocalizedString(@"Twitter", nil);
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
  viewController.navigationItem.rightBarButtonItem = cancelButton;
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  [self presentModalViewController:navigationController animated:YES];
  
}


- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  scrollView.contentInset = contentInsets;
  scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  scrollView.contentInset = contentInsets;
  scrollView.scrollIndicatorInsets = contentInsets;
}



- (void)viewDidLoad {
  [super viewDidLoad];
  [self registerForKeyboardNotifications];
  
  UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  [(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-80)];
  scrollView = (UIScrollView *)self.view;
  [self.submitButton setTitleShadowOffset:CGSizeMake(0,  0)];
  [self.submitButton setEnabled:NO];
  
  
}



#pragma mark Facebbok Session Delegate
- (void)fbDidLogin {
  NSString *token = [[[FacebookSingleton sharedFacebook] accessToken] copy];
  NSDate *expirationDate = [[FacebookSingleton sharedFacebook] expirationDate];
  NSString *appID = @"221310351230872";
  
  NSTimeInterval time = [expirationDate timeIntervalSince1970];
  PBAuthWebViewController *viewController = [[PBAuthWebViewController alloc] initWithNibName:@"PBAuthWebViewController" bundle:nil];
//  NSString *s = [NSString stringWithFormat:@"http://smokey.picbounce.com/users/auth/facebooksso?expires=%d &fb_access_token=%@&fb_app_id=%@",time,token,appID];
  
  
  

  NSString *s = [NSString stringWithFormat:@"http://smokey.picbounce.com/users/auth/facebooksso?fb_access_token=%@&fb_app_id=%@&expires=%d",token,appID,time];
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
  [request setRequestMethod:@"POST"];
  [request setDelegate:self];
  [request setWillRedirectSelector:@selector(request:willRedirectToURL:)];
  [request startAsynchronous];
  
                             
  
  NSLog(@"%@",token);
}


-(void) request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)url {
  NSString *urlString = [url absoluteString];
  NSRange range = [urlString rangeOfString:@"picbounce?auth_token"];
  
  if (range.length > 0) {
    NSString *key = [urlString substringFromIndex:range.location+range.length+1];
    [(PathBoxesAppDelegate *) [[UIApplication sharedApplication] delegate] setAuthToken:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGGED_IN" object:nil];
    [self dismissModalViewControllerAnimated:YES];
  }
 
  [request redirectToURL:url];
}

-(void) requestDidFinish:(ASIHTTPRequest *)request{
  NSLog(@""); 
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
  
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
  
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if ([emailTextField.text length] > 0 || [passwordTextField.text length] > 0) {
    self.submitButton.enabled = YES;
  }
  else  {
    self.submitButton.enabled = NO;
  }
  
  return YES;
}
@end