//
//  PicBounce2AppDelegate.m
//  PicBounce2
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "AppDelegate.h"
#import "PBExpandingPhotoView.h"
#import "PBContainerView.h"
#import "FacebookSingleton.h"
#import "ABNotifier.h"
#import "CaptureSessionManager.h"
#import "PBLoginViewController.h"
#import "PBSharedUser.h"
#import "PBNavigationController.h"
#import "PBNewCameraViewController.h"

@implementation AppDelegate

static NSString *kAuthTokenPersistanceKey = @"AUTH_TOKEN";
static NSString *kAPNSPersistanceKey = @"APNS_DEVICE_TOKEN"; 
static NSString *hopToadAPIKey = @"57b7289a9cad881773f2ebcc303ff2db";


@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize authToken = _authToken;
@synthesize currentController = _currentController;
@synthesize usingCameraView;

-(void) setAuthToken:(NSString *)authToken {
  [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kAuthTokenPersistanceKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  _authToken = authToken;
  [_authToken retain];
}


-(NSString *) authToken {
  if (!_authToken) {
    _authToken = [[[NSUserDefaults standardUserDefaults] objectForKey:kAuthTokenPersistanceKey] retain];
  }
  return _authToken;
}

-(void) setCurrentViewController:(UIViewController *)currentController {
  _currentController = currentController;
  [_currentController retain];
}


-(UIViewController *) currentViewController {
  return _currentController;
}

-(void) presentLoginViewController:(BOOL)useCameraViewController {
  loginViewController = [[PBLoginViewController alloc] initWithNibName:@"PBLoginViewController" bundle:nil];
  if (useCameraViewController == YES)
  {
    [self.currentController presentModalViewController:loginViewController animated:YES];
    usingCameraView = YES;
  }
  else
  {
    [self.tabBarController presentModalViewController:loginViewController animated:YES];
    usingCameraView = NO;
  }
  [loginViewController release];
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:@"USER_LOGGED_IN" object:nil];
  
  [ABNotifier startNotifierWithAPIKey:hopToadAPIKey environmentName:ABNotifierDevelopmentEnvironment useSSL:YES delegate:nil];
  
  
  feedViewController.baseURL = [NSString stringWithFormat:@"http://%@/api/users/me/feed.json",API_BASE];
  feedViewController.shouldShowUplodingItems = NO;
  feedViewController.shouldShowProfileHeader = NO;
  feedViewController.pullsToRefresh = YES;
  
  
 
  profileViewController.baseURL = [NSString stringWithFormat:@"http://%@/api/users/me/posts",API_BASE];
  profileViewController.shouldShowUplodingItems = YES;
  profileViewController.shouldShowProfileHeader = YES;
  profileViewController.pullsToRefresh = YES;
  
  
  
  [self.window addSubview:self.tabBarController.view];
  [self.window makeKeyAndVisible];
    
  if ([self authToken] == nil) {
    [self presentLoginViewController:NO];
  }

  // Set up facebook session if expiry date not expired
  Facebook *_facebook = [FacebookSingleton sharedFacebook];
	if (_facebook != nil) {
		NSString *token = [PBSharedUser facebookAccessToken];
		NSDate *exp = [PBSharedUser facebookExpirationDate];
    
		if (token != nil && exp != nil && [token length] > 2) {
			_facebook.accessToken = token;
      _facebook.expirationDate = [NSDate distantFuture];
		} 
    
		[_facebook retain];
	}
  
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAPNSPersistanceKey];
  NSLog(@"APNS Device Token: %@",deviceToken);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


-(void) cameraButtonPressed:(id) sender {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
    UIImagePickerController *photoLibraryPicker = [[UIImagePickerController alloc] init];
    photoLibraryPicker.delegate = cameraViewController;
    [self.tabBarController presentModalViewController:photoLibraryPicker animated:YES];
    [photoLibraryPicker release];
  }
  else {
    //PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:cameraViewController];
    //[nav setStyle:1];
    //nav.navigationBarHidden = YES;
    PBNewCameraViewController *nav = [[PBNewCameraViewController alloc] init];
    [self.tabBarController presentModalViewController:nav animated:YES];
    [nav release];
  }
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [[FacebookSingleton sharedFacebook] handleOpenURL:url];
}

#pragma mark -
#pragma mark Push Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSString *storedDeviceToken = [[NSString alloc] initWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kAPNSPersistanceKey] encoding:NSUTF8StringEncoding];
  
  NSString *newDeviceToken = [deviceToken description];
  newDeviceToken = [newDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
  newDeviceToken = [newDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
  
  if (![storedDeviceToken isEqualToString:newDeviceToken]) {
    apnsToken = [newDeviceToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"/users/me/device?apns_token=%@&auth_token=%@",apnsToken,self.authToken];
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@",API_BASE,path];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(saveAPNSTokenRequestDidFinish:)];
    [request setDidFailSelector:@selector(saveAPNSTokenRequestDidFail:)];
    [request startAsynchronous];
  }
  [storedDeviceToken release];
  NSLog(@"APNS Device Token: %@",deviceToken);
}
 
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  
}

-(void) saveAPNSTokenRequestDidFinish:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] == 200) {
    [[NSUserDefaults standardUserDefaults] setObject:apnsToken forKey:@"APNS_DEVICE_TOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}


-(void) saveAPNSTokenRequestDidFail:(ASIHTTPRequest *)request {
  NSLog(@"Saving APNS Token Failed");
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  NSDictionary *aps = [userInfo objectForKey:@"aps"];
  NSUInteger badgeCount = [[aps objectForKey:@"badge"] intValue];
  NSString *alertText = [aps objectForKey:@"alert"];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
  if (alertText) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
}
#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  self.tabBarController = nil;
  self.window = nil;
  [super dealloc];
}

-(void) xxx {
  if (usingCameraView == YES)
    [self.currentController dismissModalViewControllerAnimated:YES];
  else
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}

-(void) userDidLogin:(id)dender {
  [self performSelector:@selector(xxx) withObject:nil afterDelay:0.5];
}

@end
