//
//  PBProfileHeaderView.m
//  PicBounce2
//
//  Created by Brad Smith on 04/08/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBProfileHeaderView.h"
#import "NSDictionary+NotNull.h"
#import <QuartzCore/QuartzCore.h>

static const NSUInteger kPaddingBetweenNameLabelAndVerifiedIcon = 3;


@implementation PBProfileHeaderView

@synthesize nameLabel = _nameLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize photoCountButton = _photoCountButton;
@synthesize followersCountButton = _followersCountButton;
@synthesize followButton = _followButton;
@synthesize isFollowingYouLabel = _isFollowingYouLabel;
@synthesize user = _user;
@synthesize verifiedIconImageView = _verifiedIconImageView;

- (void)dealloc {
  [_user removeObserver:self forKeyPath:@"post_count"];
  [_user removeObserver:self forKeyPath:@"followers_count"];
  [_user release];
  [_followingRequest cancel];
  [_followingRequest release];
  [_followButton release];
  [_photoCountButton release];
  [_followersCountButton release];
  [_avatarImageView release];
  [_nameLabel release];
  [_verifiedIconImageView release];
  [super dealloc];
}


-(void) updateUI {
  self.avatarImageView.layer.cornerRadius = 8;
  self.avatarImageView.layer.masksToBounds = YES;
  
  NSString *name = [_user objectForKeyNotNull:@"name"];
  NSNumber *followersCount = [_user objectForKeyNotNull:@"follower_count"];
  NSNumber *photosCount = [_user objectForKeyNotNull:@"post_count"];
  
  NSString *avatarURL = [_user objectForKeyNotNull:@"avatar"];
  if (![avatarURL isEqual:[NSNull null]]) {
    self.avatarImageView.imageURL = [NSURL URLWithString: avatarURL];
  }
  
  
  BOOL verified = [[_user objectForKeyNotNull:@"verified"] boolValue];
  self.verifiedIconImageView.hidden = !verified;
  [self.followButton setUser:_user];
  
  
  BOOL followsMe = [[_user objectForKeyNotNull:@"follows_me"] boolValue];
  if (followsMe) {
    self.isFollowingYouLabel.text = [NSString stringWithFormat:@"%@ is following you",name];
  }
  else {
    self.isFollowingYouLabel.text = [NSString stringWithFormat:@"%@ is not following you",name];
  }
  
  self.nameLabel.text = name;
  [self.photoCountButton setTitle:[photosCount stringValue] forState:UIControlStateNormal];
  [self.followersCountButton setTitle:[followersCount stringValue] forState:UIControlStateNormal]; 
}



-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (object == _user) { //Sanity Check
    [self updateUI];
  }
}


-(void) setUser:(NSDictionary *)user {
  if (_user == user) {
    return;
  }
  
  if (_user) {
    [_user removeObserver:self forKeyPath:@"post_count"];
    [_user removeObserver:self forKeyPath:@"followers_count"];
    [_user release];
  }
  
  _user = [user retain];
  [_user addObserver:self forKeyPath:@"post_count" options:NSKeyValueChangeReplacement context:nil];
  [_user addObserver:self forKeyPath:@"followers_count" options:NSKeyValueChangeReplacement context:nil];
  
  [self updateUI];
}


-(void) layoutSubviews {
  //Float the Verified Logo to the right of the name
  CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:self.nameLabel.bounds.size];
  CGRect verifiedIconFrame = self.verifiedIconImageView.frame;
  verifiedIconFrame.origin.x = self.nameLabel.frame.origin.x + nameLabelSize.width + kPaddingBetweenNameLabelAndVerifiedIcon;
  self.verifiedIconImageView.frame = verifiedIconFrame;
}

@end
