//
//  FacebookButton.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "FacebookButton.h"
#import "PBSharedUser.h"

@implementation FacebookButton

- (id)initWithPosition:(CGPoint)position {
	CGRect frame = CGRectMake(position.x, position.y, 56, 27);
    if ((self = [super initWithFrame:frame])) {
            // Initialization code
		[self setBackgroundImage:[UIImage imageNamed:@"btn_facebook_off_n"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"btn_facebook_off_s"] forState:UIControlStateSelected];
		[self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)touched:(id)sender {
	[self setSelected:!self.selected];
  [PBSharedUser setShouldCrosspostToFB:self.selected];
}

-(void) setSelected:(BOOL)selected {
  [super setSelected:selected];
  if (selected) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_facebook_on_n"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"btn_facebook_on_s"] forState:UIControlStateSelected];
  }
  else {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_facebook_off_n"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"btn_facebook_off_s"] forState:UIControlStateSelected];
  }
  
}


@end
