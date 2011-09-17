//
//  PBPersonTableViewCell.h
//  PicBounce2
//
//  Created by Brad Smith on 08/09/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface PBPersonTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EGOImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *followButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *followSpinner;
- (IBAction)followButtonPressed:(id)sender;

@end
