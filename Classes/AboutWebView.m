//
//  AboutWebView.m
//  PicBounce2
//
//  Created by Nitin on 4/21/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "AboutWebView.h"



@implementation AboutWebView

@synthesize PicBounceWeb;

@synthesize  link;

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
    [super viewDidLoad];
   
    
    PicBounceWeb = [[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
    PicBounceWeb.delegate = self;
    PicBounceWeb.scalesPageToFit = YES;
    [self.view addSubview:PicBounceWeb];
    
    
    progressbar = [[MBProgressHUD alloc] initWithView:self.view];
    [PicBounceWeb addSubview:progressbar];

    
    
    
    if (link == 1) {
       
      urlAddress = @"http://www.picbounce.com";//open the address for flag link == 1
        
    }
    else if(link == 2){
   
        urlAddress = @"http://picbounce.com/Picbounce-Legal.pdf";// open the address for flag link == 2
    
    }
    else if(link == 3){
        
        urlAddress = @"http://picbounce.com/Privacy.pdf ";// open the address for flag link == 3
        
    }

    
    NSURL *url = [NSURL URLWithString:urlAddress];
   
    
   
   
    //URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[PicBounceWeb loadRequest:requestObj];

    
    
}
///////////webview delegates/////////////////////



- (void)webViewDidStartLoad:(UIWebView *)webView { 
    
      
    progressbar.labelText = NSLocalizedString(@"Loading...", nil) ;
    [progressbar showUsingAnimation:YES];
    
    


}
- (void)webViewDidFinishLoad:(UIWebView *)webView { 

    [progressbar performSelector:@selector(hideUsingAnimation:) withObject:self];//hide the progress bar         
    
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
