//
//  PhotoCell.m
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBPhotoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOImageButton.h"
#import "PBCommentListViewController.h"

//#define PhotoCellHeight 363

#define PhotoCellHeight 390
@implementation PBPhotoCell
@synthesize tableViewController;
@synthesize viewCountLabel;
@synthesize bounceCountLabel;
@synthesize bounceButton;
@synthesize photoImageView;
@synthesize commentLabel;
@synthesize commentCountLabel;
@synthesize leaveCommentButton;
@synthesize cell;
@synthesize followersScrollView;
@synthesize avatarImageView;
@synthesize commentView1;
@synthesize commentView2;
@synthesize commentView3;
@synthesize comment1AvaratImageView;
@synthesize comment2AvaratImageView;
@synthesize comment3AvaratImageView;
@synthesize comment1NameLabel;
@synthesize comment2NameLabel;
@synthesize comment3NameLabel;
@synthesize comment1CommentLabel;
@synthesize comment2CommentLabel;
@synthesize comment3CommentLabel;
@synthesize comment1TimeLabel;
@synthesize comment2TimeLabel;
@synthesize comment3TimeLabel;


-(void) awakeFromNib {
  followersScrollView.backgroundColor = [UIColor clearColor];
 for (int c=0; c<30; c++) {
   UIView *view = [[EGOImageButton alloc] initWithPlaceholderImage:nil];
   view.frame = CGRectMake(0, 0, 20, 20);
   view.backgroundColor = [UIColor darkGrayColor];
   view.layer.cornerRadius = 0;
   [self addPhotoView:view ToFollowerScrollViewAtIndex:c];
  
 }
  followersScrollView.showsHorizontalScrollIndicator = NO;
  followersScrollView.pagingEnabled = YES;
  
  UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentView1Tapped:)];
   UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentView2Tapped:)];
  [commentView1 addGestureRecognizer:tgr];
  [commentView2 addGestureRecognizer:tgr2];
  
  comment1AvaratImageView.backgroundColor = [UIColor lightGrayColor];
  comment2AvaratImageView.backgroundColor = [UIColor lightGrayColor];
  
  comment3AvaratImageView.backgroundColor = [UIColor lightGrayColor];
  
  
}


-(void) commentView1Tapped:(id)sender {
  self.tableViewController.title = @"Back";
  PBCommentListViewController *commentViewController = [[PBCommentListViewController alloc] initWithNibName:@"PBCommentListViewController" bundle:nil];
  commentViewController.hidesBottomBarWhenPushed = YES;
  [self.tableViewController.navigationController pushViewController:commentViewController animated:YES];
  [commentViewController release];
}

-(void) commentView2Tapped:(id)sender {
  NSLog(@"");
}
-(void) addPhotoView:(UIView *)view ToFollowerScrollViewAtIndex:(NSUInteger) index {
  view.frame = CGRectMake(index * 25, 0, 20, 20);
	
  [followersScrollView addSubview:view];
  followersScrollView.delaysContentTouches = YES;
  if ((index+1) * 25 > followersScrollView.contentSize.width) {
    followersScrollView.contentSize = CGSizeMake((index+1) * 25, followersScrollView.contentSize.height);
  }
}


-(void) dealloc {
  self.viewCountLabel = nil;
  self.bounceCountLabel = nil;
  self.bounceButton = nil;
  self.photoImageView = nil;
  self.commentLabel = nil;
  self.commentCountLabel = nil;
  self.leaveCommentButton = nil;
  self.followersScrollView = nil;
  self.avatarImageView = nil;
  self.commentView1 = nil;
  self.commentView2 = nil;
  self.commentView3 = nil;
  self.comment1AvaratImageView = nil;
  self.comment2AvaratImageView = nil;
  self.comment3AvaratImageView = nil;
  self.comment1NameLabel = nil;
  self.comment2NameLabel = nil;
  self.comment3NameLabel = nil;
  self.comment1CommentLabel = nil;
  self.comment2CommentLabel = nil;
  self.comment3CommentLabel = nil;
  self.comment1TimeLabel = nil;
  self.comment2TimeLabel = nil;
  self.comment3TimeLabel = nil;
  [super dealloc];
}


+ (CGFloat) height {
  return PhotoCellHeight;
}



@end
