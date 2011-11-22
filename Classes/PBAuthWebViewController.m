//
//  PBAuthWebViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 5/19/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBAuthWebViewController.h"
#import "AppDelegate.h"
#import "PBSharedUser.h"
@implementation PBAuthWebViewController

@synthesize webView = _webView;
@synthesize progressView = _progressView;
@synthesize authenticationURLString = _authenticationURLString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc {
  self.webView = nil;
  self.progressView = nil;
  self.authenticationURLString = nil;
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
  
  NSHTTPCookie *cookie;
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (cookie in [storage cookies]) {
    [storage deleteCookie:cookie];
  }
  
  UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  self.webView.backgroundColor = self.view.backgroundColor;
  self.webView.alpha = 0;
  
  self.progressView = [[PBProgressHUD alloc] initWithView:self.view];
  self.progressView.labelText = @"Loading...";
}

- (void) viewWillAppear:(BOOL)animated {
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.authenticationURLString]]];
}

- (void)viewDidUnload {
  self.progressView = nil;
  self.webView = nil;
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *urlString = [[request URL] absoluteString];
  NSRange range = [urlString rangeOfString:@"picbounce?auth_token"];
  
  if (range.length > 0) {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"picbounce\\?auth_token=(([a-z]|\\d)+)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange patt = [pattern rangeOfFirstMatchInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
    NSString *key = [[[urlString substringWithRange:patt] componentsSeparatedByString:@"="] lastObject];
    [(AppDelegate *) [[UIApplication sharedApplication] delegate] setAuthToken:key];
    
    pattern = [NSRegularExpression regularExpressionWithPattern:@"user_id=(\\d+)" options:NSRegularExpressionCaseInsensitive error:nil];
    patt = [pattern rangeOfFirstMatchInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
    NSString *userID = [[[urlString substringWithRange:patt] componentsSeparatedByString:@"="] lastObject];
    [PBSharedUser setUserID:userID];

    pattern = [NSRegularExpression regularExpressionWithPattern:@"screen_name=(.+)" options:NSRegularExpressionCaseInsensitive error:nil];
    patt = [pattern rangeOfFirstMatchInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
    NSString *name = [[[urlString substringWithRange:patt] componentsSeparatedByString:@"="] lastObject];
    [PBSharedUser setName:name];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGGED_IN" object:nil];

    return NO;
  }
  
  return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
  [self.view addSubview:self.progressView];
  [self.progressView showUsingAnimation:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.progressView hide:YES];
  [UIView animateWithDuration:0.33 
                        delay:0.33 
                      options:UIViewAnimationOptionTransitionNone 
                   animations:^(void) {
                     self.webView.alpha = 1;
                   }    
                   completion:nil];
  
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  
}

-(void) setTitle:(NSString *)title {
  [super setTitle:title];
  UILabel *l = (UILabel *)self.navigationItem.titleView;
  
  if ([l.text isEqualToString:self.navigationItem.title] == NO) {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = kNavBarTitleTextColor
    
    label.text = self.navigationItem.title;
    [label sizeToFit];
    self.navigationItem.titleView = label;
  }
}

@end
