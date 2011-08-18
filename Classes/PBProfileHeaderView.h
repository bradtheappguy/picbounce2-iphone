//
//  PBProfileHeaderView.h
//  PicBounce2
//
//  Created by Brad Smith on 04/08/2011.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface PBProfileHeaderView : UIView {
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *avatarImageView;
@property (nonatomic, retain) IBOutlet UIButton *photoCountButton;
@property (nonatomic, retain) IBOutlet UIButton *followingCountButton;
@property (nonatomic, retain) IBOutlet UIButton *followersCountButton;

- (IBAction)photoCountButtonPressed:(id)sender;
- (IBAction)followingCountButtonPressed:(id)sender;
- (IBAction)followersCountButtonPressed:(id)sender;

@end
