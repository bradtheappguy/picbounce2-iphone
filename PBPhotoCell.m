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

#define PhotoCellHeight 385
@implementation PBPhotoCell
@synthesize tableViewController;
@synthesize viewCountLabel;
@synthesize bounceCountLabel;
@synthesize bounceButton;
@synthesize photoImageView;
@synthesize commentLabel;
@synthesize commentCountLabel;
@synthesize leaveCommentButton;
@synthesize personCountLabel;
@synthesize hashTagCountLabel;
@synthesize likeCountLabel;

-(void) awakeFromNib {

 for (int c=0; c<30; c++) {
   UIView *view = [[EGOImageButton alloc] initWithPlaceholderImage:nil];
   view.frame = CGRectMake(0, 0, 20, 20);
   view.backgroundColor = [UIColor darkGrayColor];
   view.layer.cornerRadius = 0;
   [self addPhotoView:view ToFollowerScrollViewAtIndex:c];
  
 }


  
  
}


-(void) addPhotoView:(UIView *)view ToFollowerScrollViewAtIndex:(NSUInteger) index {
  view.frame = CGRectMake(index * 25, 0, 20, 20);
}


-(void) dealloc {
  self.viewCountLabel = nil;
  self.bounceCountLabel = nil;
  self.bounceButton = nil;
  self.photoImageView = nil;
  self.commentLabel = nil;
  self.commentCountLabel = nil;
  self.leaveCommentButton = nil;


  [super dealloc];
}


+ (CGFloat) height {
  return PhotoCellHeight;
}



@end
