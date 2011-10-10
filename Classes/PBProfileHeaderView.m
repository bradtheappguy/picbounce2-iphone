//
//  PBProfileHeaderView.m
//  PicBounce2
//
//  Created by Brad Smith on 04/08/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBProfileHeaderView.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "PBHTTPRequest.h"

@implementation PBProfileHeaderView
@synthesize nameLabel = _nameLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize photoCountButton = _photoCountButton;
@synthesize followingCountButton = _followingCountButton;
@synthesize followersCountButton = _followersCountButton;
@synthesize followButton = _followButton;
@synthesize unfollowButton = _unfollowButton;
@synthesize isFollowingYouLabel = _isFollowingYouLabel;

- (void)dealloc {
  [_unfollowButton release];
  [_followingRequest cancel];
  [_followingRequest release];
  [_followButton release];
  [_photoCountButton release];
  [_followingCountButton release];
  [_followersCountButton release];
  [_avatarImageView release];
  [_nameLabel release];
  [super dealloc];
}

#pragma mark Button Handeling
- (IBAction)photoCountButtonPressed:(id)sender {
}
- (IBAction)followingCountButtonPressed:(id)sender {  
}
- (IBAction)followersCountButtonPressed:(id)sender {
}

- (IBAction)followButtonPressed:(id)sender {
  NSString *userID = [_user objectForKey:@"id"];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/followings.json?user_id=%@",API_BASE,userID]];
  
  if (_followingRequest) {
    [_followingRequest cancel];
    [_followingRequest release];
    _followingRequest = nil;
  }
  _followingRequest = [[PBHTTPRequest requestWithURL:url] retain];
  _followingRequest.requestMethod = @"POST";
  _followingRequest.delegate = self;
  [_followingRequest setDidFailSelector:@selector(followingRequestDidFail:)];
  [_followingRequest setDidFinishSelector:@selector(followingRequestDidFinish:)];
  [_followingRequest startAsynchronous];
}


- (IBAction)unfollowButtonPressed:(id)sender {
  NSString *userID = [_user objectForKey:@"id"];
  NSString *authToken = [(AppDelegate *)[[UIApplication sharedApplication] delegate] authToken];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/followings/%@.json?user_id=%@&auth_token=%@",API_BASE,userID,userID,authToken]];
  
  if (_followingRequest) {
    [_followingRequest cancel];
    [_followingRequest release];
    _followingRequest = nil;
  }
  _followingRequest = [[ASIHTTPRequest alloc] initWithURL:url];
  _followingRequest.requestMethod = @"DELETE";
  _followingRequest.delegate = self;
  [_followingRequest setDidFailSelector:@selector(unfollowRequestDidFail:)];
  [_followingRequest setDidFinishSelector:@selector(unfollowRequestDidFinish:)];
  [_followingRequest startAsynchronous];
}

-(void) setUser:(NSDictionary *)user {
  _user = user;
  NSString *name = [user objectForKey:@"display_name"];
  NSNumber *followingCount = [user objectForKey:@"following_count"];
  NSNumber *followersCount = [user objectForKey:@"followers_count"];
  NSNumber *photosCount = [user objectForKey:@"photo_count"];
  BOOL followsMe = [[user objectForKey:@"follows_me"] boolValue];
  if (followsMe) {
    self.isFollowingYouLabel.text = [NSString stringWithFormat:@"%@ is following you",name];
  }
  else {
    self.isFollowingYouLabel.text = [NSString stringWithFormat:@"%@ is not following you",name];
  }
  
  BOOL following = [[user objectForKey:@"following"] boolValue];
  if (following) {
    self.followButton.hidden = YES;
    self.unfollowButton.hidden = NO;
  }	
  else {
    self.followButton.hidden = NO;
    self.unfollowButton.hidden = YES;
  }
  
  self.nameLabel.text = name;
  [self.photoCountButton setTitle:[photosCount stringValue] forState:UIControlStateNormal];
  [self.followersCountButton setTitle:[followersCount stringValue] forState:UIControlStateNormal];
  [self.followingCountButton setTitle:[followingCount stringValue] forState:UIControlStateNormal];
  
  
}

-(void) followingRequestDidFail:(ASIHTTPRequest *)followingRequest {
  
}

-(void) followingRequestDidFinish:(ASIHTTPRequest *)followingRequest {
  if (followingRequest.responseStatusCode == 200) {
    [self.followButton setHidden:YES];
    [self.unfollowButton setHidden:NO];
  }
}

-(void) unfollowRequestDidFail:(ASIHTTPRequest *)followingRequest {
  
}

-(void) unfollowRequestDidFinish:(ASIHTTPRequest *)followingRequest {
  if (followingRequest.responseStatusCode == 200) {
    [self.unfollowButton setHidden:YES];
    [self.followButton setHidden:NO];
  }
}

@end
