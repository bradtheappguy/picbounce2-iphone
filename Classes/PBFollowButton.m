//
//  PBFollowButton.m
//  PicBounce2
//
//  Created by Brad Smith on 22/07/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBFollowButton.h"
#import "NSDictionary+NotNull.h"
#import "PBSharedUser.h"
#import "PBProgressHUD.h"
#import "PBAPI.h"

@interface PBFollowButton (private)
-(void) setMode:(PBFollowButtonMode)mode;
-(void) showUnfollowConfimationActionSheet;
-(void) performRequestToSetFollowing:(BOOL)follow;
-(void) buttonPressed;
-(void) actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void) followRequestDidFinish:(PBHTTPRequest *)request;
-(void) followRequestDidFail:(PBHTTPRequest *)request;
-(void) unfollowRequestDidFinish:(PBHTTPRequest *)request;
-(void) unfollowRequestDidFail:(PBHTTPRequest *)request;
-(void) userWasFollowed:(NSNotification *)sender;
-(void) userWasUnfollowed:(NSNotification *)sender;
@end

@implementation PBFollowButton

@synthesize user= _user;
@synthesize viewController = _viewController;

#pragma mark -
#pragma mark lifececle
-(void) awakeFromNib {
  [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  spinner.hidesWhenStopped = YES;
  spinner.center = self.center;
  [spinner stopAnimating];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWasFollowed:) name:PBAPIUserWasFollowedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWasUnfollowed:) name:PBAPIUserWasUnfollowedNotification object:nil];
}

-(void) dealloc {
  [_followingRequest setDelegate:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:PBAPIUserWasFollowedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:PBAPIUserWasUnfollowedNotification object:nil];
  [super dealloc];
}


-(void) setUser:(NSDictionary *)user {
  [_user release];
  _user = [user retain];
  
  NSNumber *userID = [user objectForKeyNotNull:@"id"];
  NSString *myUserID = [PBSharedUser userID];
  if ([[userID stringValue] isEqualToString:myUserID]) {
    self.hidden = YES;
    return;
  }

  if ([[user objectForKeyNotNull:@"is_following"] boolValue]) {
    [self setMode:PBFollowButtonModeFollowing];
  }
  else {
    [self setMode:PBFollowButtonModeNotFollowing];
  }
}


-(void) setMode:(PBFollowButtonMode)mode {
  _mode = mode;
  if (mode == PBFollowButtonModeFollowing) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_following_s.png"] forState:UIControlStateNormal];
    [self setTitle:@"Following" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [spinner stopAnimating];
  }
  else if (mode == PBFollowButtonModeNotFollowing) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_follow_s.png"] forState:UIControlStateNormal];
    [self setTitle:@"Follow" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [spinner stopAnimating];
  }
  else if (mode == PBFollowButtonModeSpinning) {
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    [[self superview] addSubview:spinner];
    [spinner startAnimating];
  }
}


- (void) showUnfollowConfimationActionSheet {
  UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Unfollow" otherButtonTitles:nil];
  [actionSheet showFromTabBar:self.viewController.tabBarController.tabBar];
  [actionSheet release];
}


-(void) performRequestToSetFollowing:(BOOL)follow {
  NSAssert(self.user, @"ERROR: USER NOT SET");
  NSString *screenName = [self.user objectForKeyNotNull:@"screen_name"];
  NSAssert(screenName, @"ERROR: USER DOES NOT HAVE A SCREEN NAME");
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/users/%@/followers",API_BASE,screenName]];
  if (_followingRequest) {
    [_followingRequest cancel];
    [_followingRequest release];
    _followingRequest = nil;
  }
  _followingRequest = [[PBHTTPRequest requestWithURL:url] retain];
  _followingRequest.delegate = self;
  if (follow) {
    _followingRequest.requestMethod = @"POST";
    [_followingRequest setDidFailSelector:@selector(followRequestDidFail:)];
    [_followingRequest setDidFinishSelector:@selector(followRequestDidFinish:)];
  }
  else {
    _followingRequest.requestMethod = @"DELETE";
    [_followingRequest setDidFailSelector:@selector(unfollowRequestDidFail:)];
    [_followingRequest setDidFinishSelector:@selector(unfollowRequestDidFinish:)];
  }
  [self setMode:PBFollowButtonModeSpinning];
  [_followingRequest startAsynchronous];
}


-(void) buttonPressed {
  if (_mode == PBFollowButtonModeSpinning) {
    return;
  }
  if (_mode == PBFollowButtonModeFollowing) {  
     [self showUnfollowConfimationActionSheet];      
  }
  if (_mode == PBFollowButtonModeNotFollowing) {
      [self performRequestToSetFollowing:YES];
  }
}




-(void) showErrorHUD {
  PBProgressHUD *errorHud = [[PBProgressHUD alloc] initWithView:[self.viewController view]];
  errorHud.mode = PBProgressHUDModeError;
  [[self.viewController view] addSubview:errorHud];
  [errorHud showUsingAnimation:YES];
  [errorHud release];
  //[errorHud dismissAfterDelay:0.66];
  
}

#pragma mark -
#pragma mark UIActionSheetDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
  if ([actionSheet destructiveButtonIndex] == buttonIndex) {
    [self performRequestToSetFollowing:NO];
  }
}


#pragma mark -
#pragma mark Network Callbacks

-(void) followRequestDidFinish:(PBHTTPRequest *)request {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.user forKey:@"user"];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBAPIUserWasFollowedNotification object:[self.user objectForKey:@"id"] userInfo:userInfo];
}


-(void) followRequestDidFail:(PBHTTPRequest *)request {
  [self showErrorHUD];
  [self setMode:PBFollowButtonModeNotFollowing];
}


-(void) unfollowRequestDidFinish:(PBHTTPRequest *)request {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.user forKey:@"user"];
  [[NSNotificationCenter defaultCenter] postNotificationName:PBAPIUserWasUnfollowedNotification object:[self.user objectForKey:@"id"] userInfo:userInfo];
}


-(void) unfollowRequestDidFail:(PBHTTPRequest *)request {
  [self showErrorHUD];
  [self setMode:PBFollowButtonModeFollowing];
}


#pragma mark -
#pragma mark - Async Listeners 
-(void) userWasFollowed:(NSNotification *)sender {
  NSDictionary *userData = [sender userInfo];
  NSString *thisUserID = [[self.user objectForKey:@"id"] stringValue];
  NSString *senderUserID = [[[userData objectForKey:@"user"] objectForKey:@"id"] stringValue];
  if ([thisUserID isEqualToString:senderUserID]) {
    [self setMode:PBFollowButtonModeFollowing];
  }
}


-(void) userWasUnfollowed:(NSNotification *)sender {
  NSDictionary *userData = [sender userInfo];
  NSString *thisUserID = [[self.user objectForKey:@"id"] stringValue];
  NSString *senderUserID = [[[userData objectForKey:@"user"] objectForKey:@"id"] stringValue];
  if ([thisUserID isEqualToString:senderUserID]) {
    [self setMode:PBFollowButtonModeNotFollowing];
  }
}
@end
