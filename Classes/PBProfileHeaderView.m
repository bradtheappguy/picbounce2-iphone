//
//  PBProfileHeaderView.m
//  PicBounce2
//
//  Created by Brad Smith on 04/08/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBProfileHeaderView.h"
#import "NSDictionary+NotNull.h"

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



-(void) setUser:(NSDictionary *)user {
  _user = user;
  NSString *name = [user objectForKeyNotNull:@"name"];
  NSNumber *followersCount = [user objectForKeyNotNull:@"follower_count"];
  NSNumber *photosCount = [user objectForKeyNotNull:@"post_count"];

  NSString *avatarURL = [user objectForKeyNotNull:@"avatar"];
  if (![avatarURL isEqual:[NSNull null]]) {
    self.avatarImageView.imageURL = [NSURL URLWithString: avatarURL];
  }
  
  BOOL verified = [[user objectForKeyNotNull:@"verified"] boolValue];
  self.verifiedIconImageView.hidden = !verified;
  [self.followButton setUser:user];
  
  
  BOOL followsMe = [[user objectForKeyNotNull:@"follows_me"] boolValue];
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


-(void) layoutSubviews {
  //Float the Verified Logo to the right of the name
  CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:self.nameLabel.bounds.size];
  CGRect verifiedIconFrame = self.verifiedIconImageView.frame;
  verifiedIconFrame.origin.x = self.nameLabel.frame.origin.x + nameLabelSize.width + kPaddingBetweenNameLabelAndVerifiedIcon;
  self.verifiedIconImageView.frame = verifiedIconFrame;
}

@end
