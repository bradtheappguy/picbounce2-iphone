//
//  PhotoCell.h
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EGOImageView.h"

@interface PBPhotoCell : UITableViewCell {
  IBOutlet UILabel *viewCountLabel;
  IBOutlet UILabel *bounceCountLabel;
  IBOutlet UIButton *bounceButton;
  IBOutlet  EGOImageView *photoImageView;
  IBOutlet  UILabel *commentLabel;
  IBOutlet UILabel *commentCountLabel;
  IBOutlet UIButton *leaveCommentButton;
  
  IBOutlet PBPhotoCell *cell;
  
  IBOutlet UIScrollView *followersScrollView;
  IBOutlet EGOImageView *avatarImageView;
  
  IBOutlet UIView *commentView1;
  IBOutlet UIView *commentView2;
  IBOutlet UIView *commentView3;
  
  IBOutlet EGOImageView *comment1AvaratImageView;
  IBOutlet EGOImageView *comment2AvaratImageView;
  IBOutlet EGOImageView *comment3AvaratImageView;
  IBOutlet UILabel *comment1NameLabel;
  IBOutlet UILabel *comment2NameLabel;
  IBOutlet UILabel *comment3NameLabel;
  IBOutlet UILabel *comment1CommentLabel;
  IBOutlet UILabel *comment2CommentLabel;
  IBOutlet UILabel *comment3CommentLabel;
  IBOutlet UILabel *comment1TimeLabel;
  IBOutlet UILabel *comment2TimeLabel;
  IBOutlet UILabel *comment3TimeLabel;
  
  
  
  
  UITableViewController *tableViewController;
}

+ (CGFloat) height;
-(void) addPhotoView:(UIView *)view ToFollowerScrollViewAtIndex:(NSUInteger) index;

@property (nonatomic, assign) UITableViewController *tableViewController;

@property (nonatomic, retain) IBOutlet PBPhotoCell *cell;
@property (nonatomic, retain) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *bounceCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *bounceButton;
@property (nonatomic, retain)IBOutlet  EGOImageView  *photoImageView;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *leaveCommentButton;
@property (nonatomic, retain) IBOutlet UIScrollView *followersScrollView;
@property (nonatomic, retain) IBOutlet EGOImageView *avatarImageView;

@property (nonatomic, retain) IBOutlet UIView *commentView1;
@property (nonatomic, retain) IBOutlet UIView *commentView2;
@property (nonatomic, retain) IBOutlet UIView *commentView3;
@property (nonatomic, retain) IBOutlet EGOImageView *comment1AvaratImageView;
@property (nonatomic, retain) IBOutlet EGOImageView *comment2AvaratImageView;
@property (nonatomic, retain) IBOutlet EGOImageView *comment3AvaratImageView;
@property (nonatomic, retain) IBOutlet UILabel *comment1NameLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment2NameLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment3NameLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment1CommentLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment2CommentLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment3CommentLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment1TimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment2TimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *comment3TimeLabel;
@end
