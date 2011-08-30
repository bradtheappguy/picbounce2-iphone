//
//  PBIconLabel.m
//  PicBounce2
//
//  Created by Brad Smith on 25/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBIconLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation PBIconLabel

@synthesize rightIcon;


-(void) awakeFromNib {
  [super awakeFromNib];
   self.rightIcon.frame = CGRectMake(self.bounds.size.width-self.rightIcon.bounds.size.width - 5, 
                                    (self.bounds.size.height-self.rightIcon.bounds.size.height)/2, 
                                    self.rightIcon.bounds.size.width, 
                                    self.rightIcon.bounds.size.height);
  
  [self addSubview:self.rightIcon];
  
  [[self layer] setCornerRadius:5.0f];
  [[self layer] setMasksToBounds:YES];
  [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.rightIcon.bounds.size.width)];
}

- (void)drawTextInRect:(CGRect)rect {
  //UIEdgeInsets insets = {0, 5, 0, self.rightIcon.bounds.size.width};
  //return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
