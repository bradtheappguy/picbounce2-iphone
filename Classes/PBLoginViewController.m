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
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "PBNavigationController.h"
#import "PBSharedUser.h"
#import "PBNavigationBarButtonItem.h"

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
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/auth/picbounce",API_BASE]]];
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

- (IBAction)tosButtonPressed:(id)sender {
  PBAuthWebViewController *viewController = [[PBAuthWebViewController alloc] initWithNibName:@"PBAuthWebViewController" bundle:nil];
  viewController.authenticationURLString = [NSString stringWithFormat:@"http://%@%@",API_BASE,@"/appsupport/iphone/tos.html"];
  viewController.title = @"Via.me";
  
  viewController.navigationItem.rightBarButtonItem = [PBNavigationBarButtonItem itemWithTitle:@"Done" target:self action:@selector(dismissModalViewControllerAnimated:)];

  
  PBNavigationController *navigationController = [[PBNavigationController alloc] initWithRootViewController:viewController];
  [self presentModalViewController:navigationController animated:YES];
  [navigationController release];
  [viewController release];


}

-(IBAction) facebookButtonPressed:(id)sender {
  
  Facebook *_facebook = nil;
  
  //BOOL isLoggedIn;
  
	if (_facebook == nil) {
		_facebook = [FacebookSingleton sharedFacebook];
		_facebook.sessionDelegate = self;
		NSString *token = [PBSharedUser facebookAccessToken];
		NSDate *exp = [PBSharedUser facebookExpirationDate];
    
		if (token != nil && exp != nil && [token length] > 2) {
			//isLoggedIn = YES;
			_facebook.accessToken = token;
      _facebook.expirationDate = [NSDate distantFuture];
		} 
    
		[_facebook retain];
	}
	
  //if no session is available login
	[_facebook authorize:[NSArray arrayWithObject: @"publish_stream"] delegate:self];
}


-(void) twitterFramework {
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  NSArray *twitterAccounts =  [accountStore accountsWithAccountType:accountType];
  if ([twitterAccounts count] < 1) {
    NSLog(@"No Twitter Account Found");
    ACAccount *newTwitterAccount = [[ACAccount alloc] initWithAccountType:accountType];
    [accountStore saveAccount:newTwitterAccount withCompletionHandler:nil];
    [newTwitterAccount release];
  }
  else {
    
    [accountStore requestAccessToAccountsWithType:accountType
                            withCompletionHandler:^(BOOL granted, NSError *error)
     {
       if (granted) {
         NSLog(@"GRANTED");
       }
       else {
         NSLog(@"Not Granted");
       }
       if (error) {
         NSLog(@"Error: %@",[error description]);
       }
     }
     ];
  }
  [accountStore release];
}

-(IBAction) twitterButtonPressed:(id)sender {
  //if (NSClassFromString(@"ACAccountStore") && NSClassFromString(@"ACAccountType")) {
  //  [self twitterFramework];
  //  return;
  //}
  PBAuthWebViewController *viewController = [[PBAuthWebViewController alloc] initWithNibName:@"PBAuthWebViewController" bundle:nil];
  viewController.authenticationURLString = [NSString stringWithFormat:@"http://%@/users/auth/twitter", API_BASE];
  viewController.title = NSLocalizedString(@"Twitter", nil);
  viewController.navigationItem.rightBarButtonItem = [PBNavigationBarButtonItem itemWithTitle:@"Cancel" target:self action:@selector(dismissModalViewControllerAnimated:)];  
  PBNavigationController *navigationController = [[PBNavigationController alloc] initWithRootViewController:viewController];
  [self presentModalViewController:navigationController animated:YES];
  [navigationController release];
  [viewController release];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  //self.navigationController.navigationBarHidden = YES;
  UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  [self.submitButton.titleLabel setShadowOffset:CGSizeMake(0,0)];
  [self.submitButton setEnabled:NO];
  
  UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_signin"]];
  logo.frame = self.navigationController.navigationBar.bounds;
  logo.contentMode = UIViewContentModeCenter;
  self.navigationItem.titleView = logo;
  [logo release];
}

#pragma mark Facebbok Session Delegate

- (void)fbDidLogin {
  NSString *token = [[FacebookSingleton sharedFacebook] accessToken];
  NSDate *expirationDate = [[FacebookSingleton sharedFacebook] expirationDate];
  NSString *appID = @"221310351230872";
  
  NSTimeInterval time = [expirationDate timeIntervalSince1970];
  
  NSString *s = [NSString stringWithFormat:@"http://%@/users/auth/facebooksso?fb_access_token=%@&fb_app_id=%@&expires=%d",API_BASE,token,appID,time];
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
  [request setRequestMethod:@"POST"];
  [request setDelegate:self];
  [request setDidFailSelector:@selector(picbounceTokenRequestDidFail:)];
  [request setWillRedirectSelector:@selector(request:willRedirectToURL:)];
  [request startAsynchronous];
  
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
