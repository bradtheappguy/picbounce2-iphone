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
