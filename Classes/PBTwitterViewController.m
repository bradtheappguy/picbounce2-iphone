//
//  TwitterView.m
//  PicBounce2
//
//  Created by Sunil on 4/29/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "PBTwitterViewController.h"


@implementation PBTwitterViewController

@synthesize authenticationURL = _authenticationURL;
@synthesize TwitWeb;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    
  
    
   
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done",nil)style:UIBarButtonItemStyleBordered target:self action:@selector(Done)] autorelease];// set the back button
    

    
    TwitWeb = [[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
   
    TwitWeb.delegate = self;
    
    TwitWeb.scalesPageToFit = YES;
    
    
    [self.view addSubview:TwitWeb];
    
    progressbar = [[PBProgressHUD alloc] initWithView:self.view];
    
    [TwitWeb addSubview:progressbar];
    

    
     urladdress = @"http://smooth-night-98.heroku.com/auth/twitter";
    // urladdress = @"http://smooth-night-98.heroku.com/auth/users/twitter";
    
    

    
    
    
    
    //URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.authenticationURL];
	
	//Load the request in the UIWebView.
	[TwitWeb loadRequest:requestObj];
    
    
    
    [super viewDidLoad];
}
-(void)Done{

    [self dismissModalViewControllerAnimated:YES];


}


- (void)webViewDidStartLoad:(UIWebView *)webView { 
    
    progressbar.labelText = NSLocalizedString(@"Loading...", nil) ;
    [progressbar showUsingAnimation:YES];
    

    
}

static NSUInteger reloadCount = 0;
- (void)webViewDidFinishLoad:(UIWebView *)webView { 
    
     [progressbar performSelector:@selector(hideUsingAnimation:) withObject:self];//hide the progress bar 
    
   
    NSString *myText = [TwitWeb stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"]; //to print the whole page returned by the the url call.

    if ([myText rangeOfString:@"Oops!"].length > 0  && reloadCount++ < 3) {
        [TwitWeb reload];
    }
    
    
    //     NSString *myText = [TwitWeb stringByEvaluatingJavaScriptFromString:@" twttr.form_authenticity_token"];/// uncomment to print only the twitter authenticity token.
    
    NSLog(@"twitter authenticity token = %@",myText);//print the data recieved. 
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{   /// handle http  loading error
    
    progressbar.labelText = NSLocalizedString(@"Error while loading...",nil) ;
    
    [progressbar performSelector:@selector(hideUsingAnimation:) withObject:self]; 
	
   
    
    
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

@end
