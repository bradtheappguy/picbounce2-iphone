//
//  HeaderTableViewCell.m
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBHeaderTableViewCell.h"

#define kSpacingBetweenClockIconAndTimeLabel 9
#define kSpacingBetweenNameLabelAndLocationLabel 20

@implementation PBHeaderTableViewCell

@synthesize avatarImage;
@synthesize nameLabel;
@synthesize locationLabel;
@synthesize timeLabel;
@synthesize clockIcon;


-(void) layoutSubviews {
	[super layoutSubviews];	
	//Float the clock icon to the left of the time label
	CGSize textSize = [timeLabel.text sizeWithFont:timeLabel.font];	
	CGFloat x = self.frame.size.width - textSize.width;
	clockIcon.center = CGPointMake(x - (clockIcon.frame.size.width) - kSpacingBetweenClockIconAndTimeLabel, clockIcon.center.y);
	
	//Float the location label to the right of the name label
	CGSize nameTextSize = [nameLabel.text sizeWithFont:nameLabel.font];
	CGFloat x2 = nameTextSize.width;
	locationLabel.center = CGPointMake(x2+(locationLabel.frame.size.width/2) + kSpacingBetweenNameLabelAndLocationLabel, locationLabel.center.y);

}



-(void) dealloc {
  self.avatarImage = nil;
  self.nameLabel = nil;
  self.locationLabel = nil;
  self.timeLabel = nil;
  self.clockIcon = nil;
  [super dealloc];
}

@end
