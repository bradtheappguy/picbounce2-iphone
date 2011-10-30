//
//  NewPostViewController.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "NewPostViewController.h"
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
#import "PBNavigationBar.h"
@implementation NewPostViewController
@synthesize isCaptionView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [super dealloc];  
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    if (isCaptionView) {
        optionButtonView.hidden = YES;
        CGRect frame = a_PostTextView.frame;
        frame.size.height += 50;
        a_PostTextView.frame = frame;
    }else {
    FacebookButton *a_FacebookButton = [[FacebookButton alloc] initWithPosition:CGPointMake(117, 164+44)];
    [a_FacebookButton setText:@"Market Edition"];
    
    a_FacebookButton.selected = YES;//[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
    [a_FacebookButton addTarget:self action:@selector(facebookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:a_FacebookButton];
    [self.view bringSubviewToFront:a_FacebookButton];
    [a_FacebookButton release];
   
    TwitterButton *a_TwitterButton = [[TwitterButton alloc] initWithPosition:CGPointMake(79, 164+44)];
    
   
    a_TwitterButton.selected = YES;//[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
    [a_TwitterButton addTarget:self action:@selector(twitterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:a_TwitterButton];
    [self.view bringSubviewToFront:a_TwitterButton];
    [a_TwitterButton release];
    
    }
        //[Utilities customizeNavigationController:self.navigationController];
   
        //[Utilities customizeNavigationBar:navBar];
    [self.navigationController setNavigationBarHidden:YES];
   
    [a_PostTextView becomeFirstResponder];
        //https://graph.facebook.com/fql?q=select%20page_id,%20type,%20name,%20page_url,pic_small%20from%20page%20where%20page_id%20in%20%28%20select%20page_id,type%20from%20page_admin%20where%20uid=me%28%29%20and%20type=%27WEBSITE%27%29?access_token=ACCESS_TOKEN_FROM_FACEBOOK
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark -
#pragma mark CustomNavigationBar Methods
- (IBAction)dismissModalViewControllerAnimated {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark Button Click Function


- (IBAction)optionButtonClicked:(id)sender {
        
  PBSharingOptionViewController *vc = [[PBSharingOptionViewController alloc] initWithNibName:@"PBSharingOptionViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];

    
/*    
	if (_facebook == nil) {
		_facebook = [FacebookSingleton sharedFacebook];
		_facebook.sessionDelegate = self;
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
		NSDate *exp = [[NSUserDefaults standardUserDefaults] objectForKey:@"exp_date"];
		
		if (token != nil && exp != nil && [token length] > 2) {
                //isLoggedIn = YES;
			_facebook.accessToken = token;
            _facebook.expirationDate = [NSDate distantFuture];
		} 
        
		[_facebook retain];aqa	
        //if no session is available login
    
	[_facebook authorize:[NSArray arrayWithObject: @"publish_stream"] delegate:self];
    
  */  
    
    
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
   //    
//        //BOOL isLoggedIn;
//    _facebook = nil;
//	if (_facebook == nil) {
//		_facebook = [FacebookSingleton sharedFacebook];
//		_facebook.sessionDelegate = self;
//		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
//		NSDate *exp = [[NSUserDefaults standardUserDefaults] objectForKey:@"exp_date"];
//		
//		if (token != nil && exp != nil && [token length] > 2) {
//                //isLoggedIn = YES;
//			_facebook.accessToken = token;
//            _facebook.expirationDate = [NSDate distantFuture];
//		} 
//        
//		[_facebook retain];
//	}
//	
//        //if no session is available login
//    
//	[_facebook authorize:[NSArray arrayWithObject: @"publish_stream"] delegate:self];
}
#pragma mark New Post Upload to Twitter 
- (IBAction)twitterButtonClicked:(id)sender {
//    PBAuthWebViewController *viewController = [[PBAuthWebViewController alloc] initWithNibName:@"PBAuthWebViewController" bundle:nil];
//    viewController.authenticationURLString = [NSString stringWithFormat:@"http://%@/users/auth/twitter", API_BASE];
//    viewController.title = NSLocalizedString(@"Twitter", nil);
//    viewController.webView.backgroundColor = [UIColor blueColor];
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
//    viewController.navigationItem.rightBarButtonItem = cancelButton;
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    [self presentModalViewController:navigationController animated:YES];
//    [navigationController release];
//    [cancelButton release];
//    [viewController release];
  
}


#pragma mark New Post Upload to Server 
- (void)postOnServer {
  [[PBUploadQueue sharedQueue] uploadText:a_PostTextView.text];
  [[(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarController] setSelectedIndex:2];
  [self dismissModalViewControllerAnimated:YES];
 
}





#pragma mark Facebbok Session Delegate
- (void)fbDidLogin {
    
    [a_PostTextView resignFirstResponder];
    
    //https://graph.facebook.com/me/likes?limit=30&access_token=AAAAAAITEghMBACvdx5UkNoSkurnNQagGhCLswGgZBfNU6zZCCAZCytvSc0xJpZBRSOJerEf3dsoWdd4sBC5mKNF8h4YZAkZAE98EjVwJRQRwZDZD
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/likes?limit=30&access_token=%@",_facebook.accessToken]];
    
    
    
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0]autorelease];
	NSURLResponse *returnedResponse = nil;
	NSError *returnedError = nil;
	NSData *itemData  = [NSURLConnection sendSynchronousRequest:request returningResponse:&returnedResponse error:&returnedError];
	NSString* theString = [[NSString alloc] initWithData:itemData encoding:NSASCIIStringEncoding];
    NSMutableArray *array = [theString JSONValue];
    NSLog(@"%@",array);
    
}
-(void) followingRequestDidFail:(ASIHTTPRequest *)followingRequest {
    
}

-(void) followingRequestDidFinish:(ASIHTTPRequest *)followingRequest {
  
  
  
  
  
  
}

//    SBJSON *jsonWriter = [[SBJSON new] autorelease];
//    
//        // The action links to be shown with the post in the feed
//    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                      @"Get Started",@"name",@"http://m.facebook.com/apps/hackbookios/",@"link", nil], nil];
//    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
//        // Dialog parameters
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"I'm using the picbounse for iOS app", @"name",
//                                   @"picbounse for iOS.", @"caption",
//                                   @"Check out picbounse for iOS to learn how you can make your iOS apps social using Facebook Platform.", @"description",
//                                   @"http://m.facebook.com/", @"link",
//                                   @"http://www.facebookmobileweb.com/", @"picture",
//                                   actionLinksStr, @"actions",
//                                   nil];
//    
//        // HackbookAppDelegate *delegate = (HackbookAppDelegate *) [[UIApplication sharedApplication] delegate];  
//    _facebook = [FacebookSingleton sharedFacebook];
//        [_facebook dialog:@"feed" andParams:params andDelegate:self];
//
    
    
//    SBJSON *jsonWriter = [[SBJSON new] autorelease];
//    
//    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                           @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
//    
//    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
//    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
//                                @"a long run", @"name",
//                                @"The Facebook Running app", @"caption",
//                                @"it is fun", @"description",
//                                @"http://itsti.me/", @"href", nil];
//    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"Share on Facebook",  @"user_message_prompt",
//                                   actionLinksStr, @"action_links",
//                                   attachmentStr, @"attachment",nil];
//    
//    [_facebook dialog:@"feed"
//           andParams:params
//         andDelegate:self];

    
//    
//    _facebook = nil;
//	if (_facebook == nil) {
//		_facebook = [FacebookSingleton sharedFacebook];
//		_facebook.sessionDelegate = self;
//		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
//		NSDate *exp = [[NSUserDefaults standardUserDefaults] objectForKey:@"exp_date"];
//		
//		if (token != nil && exp != nil && [token length] > 2) {
//                //isLoggedIn = YES;
//			_facebook.accessToken = token;
//            _facebook.expirationDate = [NSDate distantFuture];
//		} 
//        
//		[_facebook retain];
//	}
//	NSString *appID = @"221310351230872";
//    SBJSON *jsonWriter = [[SBJSON new] autorelease];
//    
//    NSString *stringDesc = [NSString stringWithFormat:@"Avnish Chuchra"];
//    
//    NSMutableDictionary *attachment = [[NSMutableDictionary alloc] init];
//    [attachment setObject:@"Sharing from My App" forKey:@"name"];
//    [attachment setObject:[NSString stringWithFormat:@"Ring - How is your Health"] forKey:@"caption"];
//    [attachment setObject:@"Testing upload" forKey:@"description"];
//    [attachment setObject:@"http://www.facebook.com/avnish.chuchra1" forKey:@"href"];
//    
//    
//    [attachment setObject:[UIImage imageNamed:@"icon.png"] forKey:@"picture"];
//    
//    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
//    [attachment release];
//    
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: appID, @"api_key", @"Share on Facebook",  @"user_message_prompt", attachmentStr, @"attachment", nil];
//
//        //if no session is available login
//    [_facebook dialog:@"stream.publish" andParams:params andDelegate:self];
//        //[_facebook authorize:[NSArray arrayWithObject: @"publish_stream"] delegate:self];
//    
//    
//    NSString *token = [[FacebookSingleton sharedFacebook] accessToken];
//    NSDate *expirationDate = [[FacebookSingleton sharedFacebook] expirationDate];
//    
//    
//    NSTimeInterval time = [expirationDate timeIntervalSince1970];
//    
//    NSString *s = [NSString stringWithFormat:@"http://%@/users/auth/facebooksso?fb_access_token=%@&fb_app_id=%@&expires=%d",API_BASE,token,appID,time];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
//    [request setRequestMethod:@"POST"];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(picbounceTokenRequestDidFail:)];
//    [request setWillRedirectSelector:@selector(request:willRedirectToURL:)];
//    [request startAsynchronous];
    

- (void)dialogDidComplete:(FBDialog*)dialog{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deal Shared!" message:@"You've successfully shared this deal on Facebook!"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
//	if (![getValDef(@"facebookPersist",[NSNumber numberWithInt:1]) boolValue])  {
//		[facebook logout:self];
//	}
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


@end
