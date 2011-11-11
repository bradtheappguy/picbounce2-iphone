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
	CGRect frame = CGRectMake(position.x, position.y, 54, 25);
    if ((self = [super initWithFrame:frame])) {
            // Initialization code
		[self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_n.png"]  forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"btn_twitter_s.png"]  forState:UIControlStateSelected];
		[self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
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
  [self setBackgroundImage:[self imageForState:(selected?UIControlStateSelected:UIControlStateNormal)] forState:UIControlStateHighlighted];
}




@end
