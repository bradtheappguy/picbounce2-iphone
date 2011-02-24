//
//  HeaderTableViewCell.m
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "HeaderTableViewCell.h"

@implementation HeaderTableViewCell

@synthesize avatarImage;
@synthesize nameLabel;
@synthesize locationLabel;
@synthesize timeLabel;

-(void) dealloc {
  self.avatarImage = nil;
  self.nameLabel = nil;
  self.locationLabel = nil;
  self.timeLabel = nil;
  [super dealloc];
}

@end
