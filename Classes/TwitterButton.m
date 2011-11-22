//
//  TwitterButton.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "TwitterButton.h"
#import "PBSharedUser.h"

@implementation TwitterButton

- (id)initWithPosition:(CGPoint)position {
	CGRect frame = CGRectMake(position.x, position.y, 56, 27);
    if ((self = [super initWithFrame:frame])) {
            // Initialization code
		[self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_off_n.png"]  forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_off_s.png"]  forState:UIControlStateSelected];
		[self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
      self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}



-(void)touched:(id)sender {
	[self setSelected:!self.selected];
  [PBSharedUser setShouldCrosspostToTW:self.selected];
}

-(void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  [super setSelected:selected];
  if (selected) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_on_n.png"]  forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_on_s.png"]  forState:UIControlStateSelected];
  }
  else {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_off_n.png"]  forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_off_s.png"]  forState:UIControlStateSelected];
  }
}




@end
