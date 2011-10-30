//
//  HeaderTableViewCell.h
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EGOImageView.h"

@interface PBPhotoHeaderView :UIView {
  IBOutlet EGOImageView *avatarImage;
  IBOutlet UILabel *nameLabel;
  IBOutlet UILabel *viewCountLabel;
  IBOutlet UILabel *timeLabel;  
  IBOutlet UIImageView *clockIcon;  

}

@property (nonatomic, retain) IBOutlet EGOImageView *avatarImage;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *clockIcon;  
@property (nonatomic, retain)  NSString *userID;  

@property (nonatomic, retain)  NSDictionary *photo;  


@end
