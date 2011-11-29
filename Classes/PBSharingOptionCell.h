//
//  PBSharingOptionCell.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBSharingOptionCell : UITableViewCell {
    UILabel *titleLabel;
    UIButton *statusButton;
}
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *statusButton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@end
