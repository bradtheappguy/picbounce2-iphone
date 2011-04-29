//
//  TwitterView.m
//  PicBounce2
//
//  Created by Sunil on 4/29/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "TwitterView.h"


@implementation TwitterView

@synthesize TwitWeb;
@synthesize scrollingWheel;


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
    
    self.title = NSLocalizedString(@"Twitter",nil);
    
    scrollingWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-200, 0, 30, 30)];
    ///alloc activity indicator
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:scrollingWheel]; ///set it to the navigation
   
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done",nil)style:UIBarButtonItemStyleBordered target:self action:@selector(Done)] autorelease];// set the back button
    

    
    TwitWeb = [[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
   
    TwitWeb.delegate = self;
    
    TwitWeb.scalesPageToFit = YES;
    
    
    [self.view addSubview:TwitWeb];
    
     urladdress = @"http://smooth-night-98.heroku.com/auth/twitter";
    
    
    NSURL *url = [NSURL URLWithString:urladdress];
    
    
    
    
    //URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[TwitWeb loadRequest:requestObj];
    
    
    [super viewDidLoad];
}
-(void)Done{

    [self dismissModalViewControllerAnimated:YES];


}


- (void)webViewDidStartLoad:(UIWebView *)webView { 
    
    [scrollingWheel startAnimating];  ///start activity indicator
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView { 
    
    [scrollingWheel stopAnimating];  /// stop activity indicator
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{   /// handle http  loading error
    
    [scrollingWheel stopAnimating];
    
    UIAlertView *myAlertView = [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:self cancelButtonTitle:NSLocalizedString( @"OK",nil) otherButtonTitles:nil]autorelease];
	
	[myAlertView show];
	
    
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if ( buttonIndex == 0)
        
	{
		NSLog(@"ok");
		[[self navigationController] popViewControllerAnimated:YES];
		
	}
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
