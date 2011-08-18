//
//  PBProfileHeaderView.m
//  PicBounce2
//
//  Created by Brad Smith on 04/08/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBProfileHeaderView.h"

@implementation PBProfileHeaderView
@synthesize nameLabel = _nameLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize photoCountButton = _photoCountButton;
@synthesize followingCountButton = _followingCountButton;
@synthesize followersCountButton = _followersCountButton;


- (void)dealloc {
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

@end
