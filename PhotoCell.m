//
//  PhotoCell.m
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PhotoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOImageButton.h"
#import "PBCommentListViewController.h"

#define PhotoCellHeight 498

@implementation PhotoCell
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


-(void) awakeFromNib {
  followersScrollView.backgroundColor = [UIColor clearColor];
 for (int c=0; c<30; c++) {
   UIView *view = [[EGOImageButton alloc] initWithPlaceholderImage:nil];
   view.frame = CGRectMake(0, 0, 20, 20);
   view.backgroundColor = [UIColor darkGrayColor];
   view.layer.cornerRadius = 2;
   [self addPhotoView:view ToFollowerScrollViewAtIndex:c];
  
 }
  followersScrollView.showsHorizontalScrollIndicator = NO;
  followersScrollView.pagingEnabled = YES;
  
  UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentView1Tapped:)];
   UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentView2Tapped:)];
  [commentView1 addGestureRecognizer:tgr];;
  [commentView2 addGestureRecognizer:tgr2];; 
}


-(void) commentView1Tapped:(id)sender {
  PBCommentListViewController *commentViewController = [[PBCommentListViewController alloc] initWithNibName:@"PBCommentListViewController" bundle:nil];
  [self.tableViewController.navigationController pushViewController:commentViewController animated:YES];
  [commentViewController release];
}

-(void) commentView2Tapped:(id)sender {
  NSLog(@"");
}
-(void) addPhotoView:(UIView *)view ToFollowerScrollViewAtIndex:(NSUInteger) index {
  view.frame = CGRectMake(index * 25, 0, 20, 20);
  [followersScrollView addSubview:view];
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
  [super dealloc];
}


+ (CGFloat) height {
  return PhotoCellHeight;
}



@end
