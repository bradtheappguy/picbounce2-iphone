//
//  PhotoCell.h
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EGOImageView.h"

@interface PhotoCell : UITableViewCell {
  IBOutlet UILabel *viewCountLabel;
  IBOutlet UILabel *bounceCountLabel;
  IBOutlet UIButton *bounceButton;
  IBOutlet  EGOImageView *photoImageView;
  IBOutlet  UILabel *commentLabel;
  IBOutlet UILabel *commentCountLabel;
  IBOutlet UIButton *leaveCommentButton;
  
  IBOutlet PhotoCell *cell;
  
  IBOutlet UIScrollView *followersScrollView;
  IBOutlet EGOImageView *avatarImageView;
  
  IBOutlet UIView *commentView1;
  IBOutlet UIView *commentView2;
  IBOutlet UIView *commentView3;
  
  UITableViewController *tableViewController;
}

+ (CGFloat) height;

@property (nonatomic, assign) UITableViewController *tableViewController;

@property (nonatomic, retain) IBOutlet PhotoCell *cell;
@property (nonatomic, retain) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *bounceCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *bounceButton;
@property (nonatomic, retain) EGOImageView  *photoImageView;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *leaveCommentButton;
@property (nonatomic, retain) IBOutlet UIScrollView *followersScrollView;
@property (nonatomic, retain) IBOutlet EGOImageView *avatarImageView;

@property (nonatomic, retain) IBOutlet UIView *commentView1;
@property (nonatomic, retain) IBOutlet UIView *commentView2;
@property (nonatomic, retain) IBOutlet UIView *commentView3;
@end
