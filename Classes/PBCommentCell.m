//
//  PBCommentCell.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBCommentCell.h"
#import "NSDictionary+NotNull.h"

@implementation PBCommentCell
@synthesize a_CommentPersonImageView;
@synthesize a_CommentCellBackGroundImageView;
@synthesize a_CommentUserNameLabel;
@synthesize a_CommentLabel;
@synthesize a_FollowButton;
@synthesize viewController = _viewController;


-(void) setComment:(NSDictionary *)comment {
  NSDictionary *user = [comment objectForKeyNotNull:@"user"];
  self.a_FollowButton.viewController = self.viewController;
  [self.a_FollowButton setUser:user];
    
  self.a_CommentUserNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
  //----- Changes color of comment to #666666
     self.a_CommentLabel.textColor = [UIColor colorWithRed:102.0f/255.0f  green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    
  self.a_CommentUserNameLabel.textColor = [UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:56.0f/255.0f alpha:1.0];
  self.a_CommentUserNameLabel.text =  [user valueForKey:@"screen_name"];
  
  
  
  CGSize size = [[comment objectForKeyNotNull:@"text"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] constrainedToSize:CGSizeMake(166, 9999) lineBreakMode:UILineBreakModeWordWrap];
  NSLog(@"%f   %f",size.width, size.height);
  
  NSInteger numOfLines = size.height / 12;
  if (numOfLines == 1) {
    self.a_CommentLabel.frame = CGRectMake(self.a_CommentLabel.frame.origin.x, self.a_CommentLabel.frame.origin.y, self.a_CommentLabel.frame.size.width, 15);
  }
  else {
    self.a_CommentLabel.frame = CGRectMake(self.a_CommentLabel.frame.origin.x, self.a_CommentLabel.frame.origin.y, self.a_CommentLabel.frame.size.width, 12*(numOfLines));
  }
  if (size.height > 30) {
    self.a_CommentCellBackGroundImageView.frame = CGRectMake(self.a_CommentCellBackGroundImageView.frame.origin.x, self.a_CommentCellBackGroundImageView.frame.origin.y, self.a_CommentCellBackGroundImageView.frame.size.width, self.a_CommentCellBackGroundImageView.frame.size.height + (12*(numOfLines) - 30));
  }
  self.a_CommentLabel.numberOfLines = numOfLines;
  self.a_CommentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
  //--- changes color of comment to #666666
     self.a_CommentLabel.textColor = [UIColor colorWithRed:102.0f/255.0f  green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    
 // self.a_CommentLabel.textColor = [UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:56.0f/255.0f alpha:1.0];
  
  self.a_CommentPersonImageView.imageURL = [NSURL URLWithString:[user objectForKeyNotNull:@"avatar"]];
  self.a_CommentLabel.text = [comment objectForKeyNotNull:@"text"];

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
