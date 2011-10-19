//
//  PBButtonWithLabel.m
//  PicBounce2
//
//  Created by Brad Smith on 25/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBButtonWithLabel.h"

@implementation PBButtonWithLabel

@synthesize label = _label;

-(void) dealloc {
  self.label = nil;
  [super dealloc];
}

-(void) setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  if (highlighted) {
    self.label.textColor = [self titleColorForState:UIControlStateHighlighted];
  }
  else {
    self.label.textColor = [self titleColorForState:UIControlStateNormal];
  }
}

@end
