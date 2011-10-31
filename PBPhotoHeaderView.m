//
//  HeaderTableViewCell.m
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBPhotoHeaderView.h"
#import "NSString+CuteTime.h"
#import "NSDictionary+NotNull.h"

#define kSpacingBetweenClockIconAndTimeLabel 5
#define kSpacingBetweenNameLabelAndLocationLabel 3

@implementation PBPhotoHeaderView

@synthesize avatarImage = _avatarImage;
@synthesize nameLabel = _nameLabel;
@synthesize viewCountLabel = _viewCountLabel;
@synthesize timeLabel = _timeLabel;
@synthesize clockIcon = _clockIcon;
@synthesize verifiedIcon = _verifiedIcon;
@synthesize userID = _userID;
@synthesize photo = _photo;

-(void) layoutSubviews {
	[super layoutSubviews];	
	//Float the clock icon to the left of the time label
  CGSize textSize = [self.timeLabel.text sizeWithFont:self.timeLabel.font];	
	CGFloat x = self.frame.size.width - textSize.width;
	self.clockIcon.center = CGPointMake(x - (self.clockIcon.frame.size.width) - kSpacingBetweenClockIconAndTimeLabel, self.clockIcon.center.y);
  
  CGSize nameTextSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font];	
	CGRect verfifiedIconFrame = self.verifiedIcon.frame;
  verfifiedIconFrame.origin.x = self.nameLabel.frame.origin.x + nameTextSize.width +kSpacingBetweenNameLabelAndLocationLabel;
  self.verifiedIcon.frame = verfifiedIconFrame;
}


-(void) setPhoto:(NSDictionary *)photo {
  _photo = photo;
  NSDictionary *user = [photo objectForKeyNotNull:@"user"];
  NSString *name = [user objectForKeyNotNull:@"name"];
  NSString *screenname = [user objectForKeyNotNull:@"screen_name"];

  NSString *avatarURL = [user objectForKeyNotNull:@"avatar"];
    
  NSString *userID = [user objectForKeyNotNull:@"id"];
  
  self.userID = userID;

  self.nameLabel.text = name;

  NSNumber *viewCount = [photo objectForKeyNotNull:@"view_count"];
  self.nameLabel.text = screenname?screenname:(name?name:@"");
  self.viewCountLabel.text = [NSString stringWithFormat:@"%@ %@",
  [viewCount stringValue],NSLocalizedString(@"Views", nil)];

  self.timeLabel.text =[(NSNumber *)[photo objectForKeyNotNull:@"created"] cuteTimeString];
  
  if (![avatarURL isEqual:[NSNull null]]) {
    self.avatarImage.imageURL = [NSURL URLWithString: avatarURL];
  }
}


-(void) dealloc {
  self.avatarImage = nil;
  self.nameLabel = nil;
  self.viewCountLabel = nil;
  self.timeLabel = nil;
  self.clockIcon = nil;
    [_verifiedIcon release];
  [super dealloc];
}

@end
