//
//  PBCommentsButton.m
//  PicBounce2
//
//  Created by Brad Smith on 11/11/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBCommentsButton.h"
#import "NSAttributedString+Attributes.h"
#import "UIColor+PBColor.h"

@implementation PBCommentsButton

static NSUInteger labelInsetLeft = 16;
static NSUInteger labelInsetRight = 5;
static NSUInteger maxLabelWidth = 160;
static NSUInteger secondaryFontSize = 10;
static NSUInteger labelInsetTop = 4;
static NSUInteger labelHeight = 12;
static NSUInteger backgroundEndCap = 30;
static NSString *backgroundImangeName = @"btn_comment_n";


-(void) awakeFromNib {
  self.titleEdgeInsets = UIEdgeInsetsMake(0, labelInsetLeft, 0, labelInsetRight);
}


-(CGSize) sizeThatFits:(CGSize)size {
  CGSize s = [label sizeThatFits:CGSizeMake(maxLabelWidth, self.bounds.size.height)];
  s.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
  s.height = self.bounds.size.height;
  return s;
}


-(void) setCommentCount:(NSUInteger)commentCount {
   
  NSString *commentsString;
  NSMutableAttributedString* attrStr;
  if (commentCount > 0) {
    NSString *base = @"  Comments ";
  
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];    
   
    commentsString = [NSString stringWithFormat:@"%@(%@)",base,[formatter stringFromNumber:[NSNumber numberWithUnsignedInt:commentCount]]];
    attrStr = [NSMutableAttributedString attributedStringWithString:commentsString];
    [attrStr setTextColor:[UIColor PBGrayButtonTextColor]];
    [attrStr setFont:[[self titleLabel] font]];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:secondaryFontSize];
    NSRange range = NSMakeRange([base length], [commentsString length] - [base length]);
    
    [attrStr setFont:font range:range];
    [attrStr setTextColor:[UIColor PBBlueTextColor] range:range];
    
  }
  else {
    commentsString = [NSString stringWithFormat:@"  Comment "];
    attrStr = [NSMutableAttributedString attributedStringWithString:commentsString];
    [attrStr setTextColor:[UIColor PBGrayButtonTextColor]];
    [attrStr setFont:[[self titleLabel] font]];
    
  }
  [self setTitle:@"" forState:UIControlStateNormal];
  
  
  label = [[OHAttributedLabel alloc] initWithFrame:
                          CGRectMake(labelInsetLeft, labelInsetTop, maxLabelWidth, labelHeight)
                          
                          ];
  label.backgroundColor = [UIColor clearColor];
  label.automaticallyAddLinksForType = 0;
  [label setAttributedText:attrStr];
  
  
  [self addSubview:label];
  [self sizeToFit];
  UIImage *backgroundImage = [[UIImage imageNamed:backgroundImangeName] stretchableImageWithLeftCapWidth:backgroundEndCap topCapHeight:0];
  [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
  [self setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
}


-(void) setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  [label setHighlighted:YES];
}
@end
