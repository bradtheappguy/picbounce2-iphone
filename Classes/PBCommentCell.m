//
//  PBCommentCell.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBCommentCell.h"

@implementation PBCommentCell
@synthesize a_CommentPersonImageView;
@synthesize a_CommentCellBackGroundImageView;
@synthesize a_CommentUserNameLabel;
@synthesize a_CommentLabel;
@synthesize a_FollowButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   a_CommentUserNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    a_CommentUserNameLabel.textColor = [UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:56.0f/255.0f alpha:1.0];
        //color:  77/255.0  65/255.0 56/255.0
    
    a_CommentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
     a_CommentLabel.textColor = [UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:56.0f/255.0f alpha:1.0];
        //color:  77/255.0  65/255.0 56/255.0
    
    return  self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
        // Configure the view for the selected state
}


- (void)dealloc {
    
	[a_CommentPersonImageView release];
    [a_CommentCellBackGroundImageView release];
	[a_CommentUserNameLabel release];
	[a_CommentLabel release];
	[a_FollowButton release];
    [super dealloc];
}

@end
