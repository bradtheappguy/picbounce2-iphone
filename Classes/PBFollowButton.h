//
//  PBFollowButton.h
//  PicBounce2
//
//  Created by Brad Smith on 22/07/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBHTTPRequest.h"

typedef enum {
  PBFollowButtonModeFollowing,
  PBFollowButtonModeNotFollowing,
  PBFollowButtonModeSpinning
} PBFollowButtonMode;

@interface PBFollowButton : UIButton <UIActionSheetDelegate>{
  @private
  PBFollowButtonMode _mode;
  PBHTTPRequest *_followingRequest;
  UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) NSDictionary *user;
@property (nonatomic, assign) UIViewController *viewController;

@end
