//
//  PathBoxesAppDelegate.m
//  PathBoxes
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "AppDelegate.h"
#import "PBExpandingPhotoView.h"
#import "PBContainerView.h"
#import "FacebookSingleton.h"
#import "HTNotifier.h"
#import "CaptureSessionManager.h"
#import "PBLoginViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize authToken = _authToken;


-(void) setAuthToken:(NSString *)authToken {
  [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"AUTH_TOKEN"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  _authToken = authToken;
  [_authToken retain];
}

-(NSString *) authToken {
  if (!_authToken) {
    _authToken = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTH_TOKEN"] retain];
  }
  return _authToken;
}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  [HTNotifier startNotifierWithAPIKey:@"57b7289a9cad881773f2ebcc303ff2db" environmentName:HTNotifierDevelopmentEnvironment];
  [feedViewController viewDidLoad];
  [profileViewController viewDidLoad];
  
  feedViewController.baseURL = [NSString stringWithFormat:@"http://%@/users/me/feed.json",API_BASE];
  feedViewController.shouldShowUplodingItems = YES;
  feedViewController.shouldShowProfileHeader = NO;
  
  
  profileViewController.shouldShowProfileHeader = YES;
  profileViewController.baseURL = [NSString stringWithFormat:@"http://%@/users/me.json",API_BASE];
  
  popularViewController.baseURL = [NSString stringWithFormat:@"http://%@/api/popular.json",API_BASE];
  
  [window addSubview:tabBarController.view];
  [window makeKeyAndVisible];
    
  
  if ([self authToken] == NO) {
    PBLoginViewController *loginViewController = [[PBLoginViewController alloc] initWithNibName:@"PBLoginViewController" bundle:nil];  
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self.tabBarController presentModalViewController:navigationController animated:YES];
    [navigationController release];
    [loginViewController release];
  }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"APNS_DEVICE_TOKEN"];
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
    [self.tabBarController presentModalViewController:cameraViewController animated:YES];
  }
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [[FacebookSingleton sharedFacebook] handleOpenURL:url];
}

#pragma mark -
#pragma mark Push Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSString *storedDeviceToken = [[NSString alloc] initWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"APNS_DEVICE_TOKEN"] encoding:NSUTF8StringEncoding];
  
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
    [request setDidFinishSelector:@selector(xxx:)];
    [request setDidFailSelector:@selector(yyy:)];
    [request startAsynchronous];
  }
  
  NSLog(@"APNS Device Token: %@",deviceToken);
  
}
 
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  
}

-(void) xxx:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] == 200) {
    NSLog(@"worked");
    [[NSUserDefaults standardUserDefaults] setObject:apnsToken forKey:@"APNS_DEVICE_TOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  
}

-(void) yyy:(ASIHTTPRequest *)request {

    NSLog(@"yyy");
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
