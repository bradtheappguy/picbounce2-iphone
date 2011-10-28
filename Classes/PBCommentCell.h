//
//  PBCommentCell.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 24/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "PBFollowButton.h"

@interface PBCommentCell : UITableViewCell {
    EGOImageView *a_CommentPersonImageView;
    UIImageView *a_CommentCellBackGroundImageView;
    UILabel *a_CommentUserNameLabel;
    UILabel *a_CommentLabel;
}

@property (nonatomic, retain) IBOutlet EGOImageView *a_CommentPersonImageView;
@property (nonatomic, retain) IBOutlet UIImageView *a_CommentCellBackGroundImageView;
@property (nonatomic, retain) IBOutlet UILabel *a_CommentUserNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *a_CommentLabel;
@property (nonatomic, retain) IBOutlet PBFollowButton *a_FollowButton;
@property (nonatomic, assign) UIViewController *viewController;
@end
