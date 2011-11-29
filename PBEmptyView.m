//
//  PBEmptyView.m
//  PicBounce2
//
//  Created by Brad Smith on 11/25/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBEmptyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PBEmptyView
@synthesize welcomeLabel;
@synthesize urlLabel;

-(void) awakeFromNib {
  
}

- (void) setUserName:(NSString *)userName {
  self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@",userName];
}

- (void) setScreenName:(NSString *)screenname {
  self.urlLabel.text = [NSString stringWithFormat:@"Upload a photo at www.via.me/%@",screenname];
  [self.urlLabel sizeToFit];
  CGRect frame = self.urlLabel.frame;
  frame.size.width += 15;
  frame.size.height = 20;
  frame.origin.x = (self.frame.size.width/2) - (frame.size.width/2);
  self.urlLabel.frame = frame;
  self.urlLabel.layer.cornerRadius = frame.size.height/2;
}


- (void)dealloc {
  [welcomeLabel release];
  [urlLabel release];
  [super dealloc];
}
@end
