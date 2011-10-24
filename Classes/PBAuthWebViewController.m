//
//  PBAuthWebViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 5/19/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBAuthWebViewController.h"
#import "AppDelegate.h"

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
    NSString *key = [urlString substringFromIndex:range.location+range.length+1];
    [(AppDelegate *) [[UIApplication sharedApplication] delegate] setAuthToken:key];

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

@end
