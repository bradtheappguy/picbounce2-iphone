//
//  PBFollowButton.h
//  PicBounce2
//
//  Created by Brad Smith on 22/07/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  PBFollowButtonModeFollowing,
  PBFollowButtonModeNotFollowing,
  PBFollowButtonModeSpinning
} PBFollowButtonMode;

@interface PBFollowButton : UIButton {
  PBFollowButtonMode _mode;
}



@property (nonatomic, retain) NSDictionary *user;
@end
