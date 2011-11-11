//
//  PBCommentsButton.m
//  PicBounce2
//
//  Created by Brad Smith on 11/11/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBCommentsButton.h"

@implementation PBCommentsButton

-(void) awakeFromNib {
  UIImage *backgroundImage = [[UIImage imageNamed:@"btn_comment_n"] stretchableImageWithLeftCapWidth:30 topCapHeight:0];
  [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
  UIImage *highlightedackgroundImage = [[UIImage imageNamed:@"btn_comment_n"] stretchableImageWithLeftCapWidth:30 topCapHeight:0];
  [self setBackgroundImage:highlightedackgroundImage forState:UIControlStateHighlighted];
  self.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 5);
}


-(CGSize) sizeThatFits:(CGSize)size {
  CGSize s = [[self titleForState:UIControlStateNormal] sizeWithFont:self.titleLabel.font];
  s.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
  return s;
}


-(void) setCommentCount:(NSUInteger)commentCount {
  NSString *commentsString;
  if (commentCount > 0) {
    commentsString = [NSString stringWithFormat:@"  Comments (%d)",commentCount];
  }
  else {
    commentsString = [NSString stringWithFormat:@"  Comment",commentCount];
  }
  [self setTitle:commentsString forState:UIControlStateNormal];
  [self sizeToFit];
}
@end
