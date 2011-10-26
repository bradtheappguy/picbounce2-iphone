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

@implementation PBFollowButton

@synthesize user= _user;
-(void) awakeFromNib {
  [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  spinner.hidesWhenStopped = YES;
  spinner.center = self.center;
  [spinner stopAnimating];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWasFollowed:) name:@"USER_WAS_FOLLOWED" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWasUnfollowed:) name:@"USER_WAS_UNFOLLOWED" object:nil];
}

-(void) setMode:(PBFollowButtonMode)mode {
  _mode = mode;
  if (mode == PBFollowButtonModeFollowing) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_following_s@2x.png"] forState:UIControlStateNormal];
    [self setTitle:@"Following" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [spinner stopAnimating];
  }
  else if (mode == PBFollowButtonModeNotFollowing) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_follow_s@2x.png"] forState:UIControlStateNormal];
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

-(void) buttonPressed {
  if (_mode == PBFollowButtonModeSpinning) {
    return;
  }
  else {
  
    
    //NSString *userID = [[self.user objectForKeyNotNull:@"user"] objectForKey:@"id"];
    NSString *screenName = [[self.user objectForKeyNotNull:@"user"] objectForKey:@"screen_name"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/users/%@/followers",API_BASE,screenName]];
    
    if (_followingRequest) {
      [_followingRequest cancel];
      [_followingRequest release];
      _followingRequest = nil;
    }
    _followingRequest = [[PBHTTPRequest requestWithURL:url] retain];
    _followingRequest.delegate = self;
    if (_mode == PBFollowButtonModeFollowing) {  
      _followingRequest.requestMethod = @"DELETE";
      [_followingRequest setDidFailSelector:@selector(unfollowRequestDidFail:)];
      [_followingRequest setDidFinishSelector:@selector(unfollowRequestDidFinish:)];
    }
    else {
      _followingRequest.requestMethod = @"POST";
      [_followingRequest setDidFailSelector:@selector(followRequestDidFail:)];
      [_followingRequest setDidFinishSelector:@selector(followRequestDidFinish:)];
    }
    
[self setMode:PBFollowButtonModeSpinning];
    [_followingRequest startAsynchronous];

  }

}

-(void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_WAS_FOLLOWED" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_WAS_UNFOLLOWED" object:nil];
  [super dealloc];
}

-(void) followRequestDidFinish:(PBHTTPRequest *)request {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.user forKey:@"user"];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_WAS_FOLLOWED" object:[self.user objectForKey:@"id"] userInfo:userInfo];
}

-(void) followRequestDidFail:(PBHTTPRequest *)request {
  [self setMode:PBFollowButtonModeNotFollowing];
}


-(void) unfollowRequestDidFinish:(PBHTTPRequest *)request {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.user forKey:@"user"];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_WAS_UNFOLLOWED" object:[self.user objectForKey:@"id"] userInfo:userInfo];
}

-(void) unfollowRequestDidFail:(PBHTTPRequest *)request {
   [self setMode:PBFollowButtonModeFollowing];
}

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
