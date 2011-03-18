//
//  ProfileHeaderCell.m
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBProfileHeaderCell.h"

@implementation PBProfileHeaderCell

@synthesize avatarIcon;
@synthesize nameLabel;
@synthesize locationLabel;
@synthesize photosCountLabel;
@synthesize followersCountLabel;
@synthesize followingCountLabel;
@synthesize badgesCountLabel;

-(void) dealloc {
  self.avatarIcon = nil;
  self.nameLabel = nil;
  self.locationLabel = nil;
  self.photosCountLabel = nil;
  self.followersCountLabel = nil;
  self.followingCountLabel = nil;
  self.badgesCountLabel = nil;
  [super dealloc];
}

@end
