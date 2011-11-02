//
//  PBSharingOptionCell.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBSharingOptionCell.h"

@implementation PBSharingOptionCell

@synthesize titleLabel;
@synthesize statusButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

  return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

  [super setSelected:selected animated:animated];
}

- (void)dealloc {

  [titleLabel release];
  [statusButton release];
  [super dealloc];
}

- (void)drawRect:(CGRect)rect {

 [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorRef blackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
  CGContextSetStrokeColorWithColor(context, blackColor);
  CGContextSetLineWidth(context, 2.0);
  CGContextStrokeRect(context, rect);
}

@end
