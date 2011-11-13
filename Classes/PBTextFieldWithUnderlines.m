//
//  PBTextFieldWithUnderlines.m
//  PicBounce2
//
//  Created by Brad Smith on 11/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBTextFieldWithUnderlines.h"


@interface PBTextFieldWithUnderlinesInternalUnderlineView : UIView 

@end
@implementation PBTextFieldWithUnderlinesInternalUnderlineView

-(void) drawRect:(CGRect)rect {
  [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGFloat lineHeight = 18 + 8;
  
  while (lineHeight < rect.size.height) {
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210/255.0 green:207/255.0 blue:207/255.0 alpha:1].CGColor);
    CGContextMoveToPoint(context, 8, lineHeight);
    CGContextAddLineToPoint(context, 210, lineHeight);
    CGContextStrokePath(context);
    lineHeight += 18;
  }

}

@end


@implementation PBTextFieldWithUnderlines


-(void) awakeFromNib {
  undelineView = [[PBTextFieldWithUnderlinesInternalUnderlineView alloc] initWithFrame:CGRectZero];
  undelineView.clipsToBounds = NO;
  undelineView.backgroundColor = [UIColor clearColor];
  undelineView.userInteractionEnabled = NO;
  [self addSubview:undelineView];
}
 




-(void) layoutSubviews {
  [super layoutSubviews];
  undelineView.frame = CGRectMake(0, 0, 300, MAX(self.contentSize.height, self.bounds.size.height));
  [undelineView setNeedsDisplay];
}

@end
