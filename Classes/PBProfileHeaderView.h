//
//  PBProfileHeaderView.h
//  PicBounce2
//
//  Created by Brad Smith on 04/08/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "ASIHTTPRequest.h"
#import "PBFollowButton.h"

@interface PBProfileHeaderView : UIView {
  NSDictionary *_user;
  ASIHTTPRequest *_followingRequest;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *avatarImageView;
@property (nonatomic, retain) IBOutlet UIButton *photoCountButton;
@property (nonatomic, retain) IBOutlet UIButton *followingCountButton;
@property (nonatomic, retain) IBOutlet UIButton *followersCountButton;
@property (nonatomic, retain) IBOutlet PBFollowButton *followButton;
@property (nonatomic, retain) IBOutlet UIButton *unfollowButton;
@property (nonatomic, retain) IBOutlet UILabel *isFollowingYouLabel;

@property (nonatomic, retain) NSDictionary *user;

- (IBAction)photoCountButtonPressed:(id)sender;
- (IBAction)followingCountButtonPressed:(id)sender;
- (IBAction)followersCountButtonPressed:(id)sender;
- (IBAction)followButtonPressed:(id)sender;
- (IBAction)unfollowButtonPressed:(id)sender;
@end
