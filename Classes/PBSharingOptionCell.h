//
//  PBSharingOptionCell.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBSharingOptionCell : UITableViewCell {
    UILabel *a_TitleLabel;
    UIButton *a_StatusButton;
}
@property (nonatomic, retain) IBOutlet UILabel *a_TitleLabel;
@property (nonatomic, retain) IBOutlet UIButton *a_StatusButton;
@end
