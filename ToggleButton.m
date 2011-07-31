//
//  ToggleButton.m
//  PicBounce2
//
//  Created by Brad Smith on 7/14/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "ToggleButton.h"

@implementation ToggleButton

- (id)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(toggleSelectedState:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

-(void) awakeFromNib {
  [self addTarget:self action:@selector(toggleSelectedState:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) toggleSelectedState:(id)sender {
  self.selected = !self.selected;
}

@end
