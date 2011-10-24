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
@synthesize userID = _userID;

-(void) layoutSubviews {
	[super layoutSubviews];	
	//Float the clock icon to the left of the time label
	
  CGSize textSize = [timeLabel.text sizeWithFont:timeLabel.font];	
	CGFloat x = self.frame.size.width - textSize.width;
	clockIcon.center = CGPointMake(x - (clockIcon.frame.size.width) - kSpacingBetweenClockIconAndTimeLabel, clockIcon.center.y);
	
	//Float the location label to the right of the name label
	//CGSize nameTextSize = [nameLabel.text sizeWithFont:nameLabel.font];
	//CGFloat x2 = nameTextSize.width;
	//locationLabel.center = CGPointMake(x2+(locationLabel.frame.size.width/2) + kSpacingBetweenNameLabelAndLocationLabel, locationLabel.center.y);
//*/
}

-(void) setPhoto:(NSDictionary *)photo {
  NSDictionary *user = [photo objectForKey:@"user"];
  NSString *name = [user objectForKey:@"name"];
  NSString *screenname = [user objectForKeyNotNull:@"screen_name"];

  NSString *avatarURL = [user objectForKey:@"avatar"];
    
  NSString *userID = [user objectForKey:@"id"];
  
  self.userID = userID;

  self.nameLabel.text = name;

  NSString *viewCount = [photo objectForKeyNotNull:@"view_count"];
  self.nameLabel.text = screenname?screenname:(name?name:@"");
  self.viewCountLabel.text = [NSString stringWithFormat:@"%@ %@",
  [viewCount stringValue],NSLocalizedString(@"Views", nil)];

  self.timeLabel.text =[(NSNumber *)[photo objectForKey:@"created"] cuteTimeString];
  
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
  [super dealloc];
}

@end
