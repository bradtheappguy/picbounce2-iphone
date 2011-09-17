//
//  PBPersonTableViewCell.m
//  PicBounce2
//
//  Created by Brad Smith on 08/09/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBPersonTableViewCell.h"

@implementation PBPersonTableViewCell
@synthesize avatarImageView;
@synthesize nameLabel;
@synthesize screenNameLabel;
@synthesize followButton;
@synthesize followSpinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
  [avatarImageView release];
  [nameLabel release];
  [screenNameLabel release];
  [followButton release];
  [followSpinner release];
  [super dealloc];
}
- (IBAction)followButtonPressed:(id)sender {
}
@end
