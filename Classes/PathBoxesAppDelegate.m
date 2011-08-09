//
//  PathBoxesAppDelegate.m
//  PathBoxes
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "PathBoxesAppDelegate.h"
#import "PBExpandingPhotoView.h"
#import "PBContainerView.h"
#import "FacebookSingleton.h"
#import "HTNotifier.h"
#import "CaptureSessionManager.h"

@implementation PathBoxesAppDelegate

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
  [HTNotifier startNotifierWithAPIKey:@"57b7289a9cad881773f2ebcc303ff2db"
                      environmentName:HTNotifierDevelopmentEnvironment];
  feedViewController.baseURL = [NSString stringWithFormat:@"http://%@/users/me/feed.json",API_BASE];
  feedViewController.shouldShowProfileHeader = NO;
  
  
  profileViewController.shouldShowProfileHeader = YES;
  profileViewController.baseURL = [NSString stringWithFormat:@"http://%@/users/me.json",API_BASE];
  
  popularViewController.baseURL = [NSString stringWithFormat:@"http://%@/api/popular.json",API_BASE];
  
  
  
  //PBContainerView *container = [[PBContainerView alloc] initWithFrame:window.frame];
  //container.backgroundColor = [UIColor colorWithRed:0.945 green:0.933 blue:0.941 alpha:1.0];
  //PBExpandingPhotoView *view1 = [[PBExpandingPhotoView alloc] initWithFrame:CGRectMake(0, 40, 320, 100)];
  //PBExpandingPhotoView *view2 = [[PBExpandingPhotoView alloc] initWithFrame:CGRectMake(0, 100+40+40, 320, 100)]; 
  // Override point for customization after application launch.
  
  //[container addSubview:view1];
  //[container addSubview:view2];
  
  [window addSubview:tabBarController.view];
    tabBarController.selectedIndex = 4;
  [window makeKeyAndVisible];
    
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
  //[[CaptureSessionManager sharedManager] addVideoInput];
  //[[CaptureSessionManager sharedManager] addVideoPreviewLayer];
    //[[[CaptureSessionManager sharedManager] captureSession] startRunning];
  
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
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
