//
//  PBFollowButton.m
//  PicBounce2
//
//  Created by Brad Smith on 22/07/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import "PBFollowButton.h"
#import "NSDictionary+NotNull.h"
@implementation PBFollowButton

@synthesize user= _user;
-(void) awakeFromNib {
  [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setMode:(PBFollowButtonMode)mode {
  if (mode == PBFollowButtonModeFollowing) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_following_s@2x.png"] forState:UIControlStateNormal];
    [self setTitle:@"Following" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  }
  else if (mode == PBFollowButtonModeNotFollowing) {
    [self setBackgroundImage:[UIImage imageNamed:@"btn_follow_s@2x.png"] forState:UIControlStateNormal];
    [self setTitle:@"Following" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  }
  else if (mode == PBFollowButtonModeSpinning) {
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = self.center;
    [spinner startAnimating];
    [[self superview] addSubview:spinner];
    [spinner release];
  }
}

-(void) setUser:(NSDictionary *)user {
  [_user release];
  _user = [user retain];
  NSLog(@"%@",user);
  
  if ([[user objectForKeyNotNull:@"user"] objectForKeyNotNull:@"is_following"]) {
    [self setMode:PBFollowButtonModeFollowing];
  }
  else {
    [self setMode:PBFollowButtonModeNotFollowing];
  }
}

-(void) buttonPressed {
  if (_mode == PBFollowButtonModeFollowing) {
    [self setMode:PBFollowButtonModeSpinning];
  }
  else if (_mode == PBFollowButtonModeNotFollowing) {
    [self setMode:PBFollowButtonModeSpinning];
  }
}

-(void) dealloc {
  [super dealloc];
}
@end
