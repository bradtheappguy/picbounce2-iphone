//
//  ProfileHeaderCell.h
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EGOImageView.h"

@interface PBProfileHeaderCell : UITableViewCell {
  IBOutlet EGOImageView *avatarIcon;
  IBOutlet UILabel *nameLabel;
  IBOutlet UILabel *locationLabel;
  IBOutlet UILabel *photosCountLabel;
  IBOutlet UILabel *followersCountLabel;
  IBOutlet UILabel *followingCountLabel;
  IBOutlet UILabel *badgesCountLabel;
}

@property (nonatomic, retain) IBOutlet EGOImageView *avatarIcon;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *photosCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *followersCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *followingCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *badgesCountLabel;
@end
