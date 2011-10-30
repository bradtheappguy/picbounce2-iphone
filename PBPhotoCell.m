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
#import "PBHTTPRequest.h"
#import "NSDictionary+NotNull.h"
#import "NSString+SBJSON.h"
#import "PBStreamViewController.h"

//#define PhotoCellHeight 363
//#define PhotoCellHeight 385
#define PhotoCellHeight 500


@implementation PBPhotoCell
@synthesize tableViewController;
@synthesize actionBar;
@synthesize photoImageView;
@synthesize captionLabel;
@synthesize commentCountLabel;
@synthesize commentCountIcon;
@synthesize leaveCommentButton;
@synthesize commentPreview;
@synthesize photo = _photo;

+(NSAttributedString *) attributedStringForComments:(NSArray *)comments withString:(NSString *)string {
  NSMutableString *comment = [[NSMutableString alloc] initWithString:@""];
  if ([comments count] < 1) {
    //[comment appendString:@"No Comments"];
  }
  
  int pos = 0;
  UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14]; 
  CTFontRef boldFont = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
  
  for (NSDictionary *c in comments) {
    NSString *name = [[[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"user"] objectForKeyNotNull:@"name"];
    NSString *text = [[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"text"];
    if (!text) {
      text = @"";
    }
    [comment appendString:name];
    pos  += [name length];
    [comment appendString:@" "];
    pos++;
    [comment appendString:text];
    [comment appendString:@"\n"];
    pos += [text length] + 1;
  }
  
  NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:comment];
  
  pos = 0;
  for (NSDictionary *c in comments) {
    NSString *name = [[[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"user"] objectForKeyNotNull:@"name"];
    NSString *text = [[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"text"];
    if (!text) {
      text = @"";
    }
    [attString addAttribute:(NSString *)kCTFontAttributeName value:(id)boldFont range:NSMakeRange(pos, [name length]-1)];
    pos  += [name length] + [text length] + 2;
  }
  return attString;
}


+(CGSize) sizeForCommentViewWithComments:(NSArray *)comments {
  NSAttributedString *attString = [PBPhotoCell attributedStringForComments:comments withString:nil];
  OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
  label.linkColor = [UIColor blueColor];
  label.font = [UIFont systemFontOfSize:14];
  label.textColor = [UIColor darkGrayColor];
  label.lineBreakMode = UILineBreakModeWordWrap;
  label.numberOfLines = 0;
  [label setAttributedText:attString];
  [label addCustomLink:[NSURL URLWithString:@"1"] inRange:NSMakeRange(0, 5)];
  
  //CGFloat height = 100.0f;
  CGSize size = [label sizeThatFits:CGSizeMake(300, 1000)];
  return CGSizeMake(300, size.height+10);
}


+(CGSize) sizeForCaptionWithString:(NSString*)string {
  CGSize size = [string sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap]; 
  
  
  
  return CGSizeMake(300, size.height+10);
  
}


+ (CGFloat) heightWithPhoto:(NSDictionary *)photo {
  NSString *caption = [photo objectForKeyNotNull:@"text"];
  CGFloat captionHeight = [PBPhotoCell sizeForCaptionWithString:caption].height;
  CGFloat photoHeight;
  if ([[photo objectForKeyNotNull:@"media_type"] isEqualToString:@"photo"]) {
    photoHeight = 300;
  }
  else {
    photoHeight = 0;
  }
  
  NSDictionary *comments = [photo objectForKeyNotNull:@"comments"];
  CGFloat commentsSize = [PBPhotoCell sizeForCommentViewWithComments:comments].height;
  
  CGFloat heoght = captionHeight + photoHeight + 35 + commentsSize + 20;
  return heoght;
}


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
  self.photoImageView = nil;
  self.captionLabel = nil;
  self.commentCountLabel = nil;
  self.leaveCommentButton = nil;
  
  
  [commentPreview release];
  [actionBar release];
  [commentCountIcon release];
  [super dealloc];
}



-(void) setComments:(NSArray *)comments {
  NSMutableAttributedString *attString = [PBPhotoCell attributedStringForComments:comments withString:nil];
  OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
  label.linkColor = [UIColor blueColor];
  label.backgroundColor = [UIColor clearColor];
  
  self.commentPreview = label;
  [self addSubview:self.commentPreview];
  label.font = [UIFont systemFontOfSize:14];
  label.textColor = [UIColor darkGrayColor];
  label.lineBreakMode = UILineBreakModeWordWrap;
  label.numberOfLines = 0;
  [label setAttributedText:attString];
  [label addCustomLink:[NSURL URLWithString:@"1"] inRange:NSMakeRange(0, 5)];
  
  //CGFloat height = 100.0f;
  CGSize size = [label sizeThatFits:CGSizeMake(300, 1000)];
  label.frame = CGRectMake(10, self.captionLabel.frame.size.height+self.photoImageView.frame.size.height+self.actionBar.frame.size.height, 300, size.height+10);
}






-(void) setPhoto:(NSDictionary *)photo {
  self.captionLabel.backgroundColor = [UIColor clearColor];
  self.actionBar.backgroundColor = [UIColor clearColor];
  self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  
  self.bounds = CGRectMake(0, 0, 320, [PBPhotoCell heightWithPhoto:photo]);
  [_photo release];
  _photo = [photo retain];
  
  NSString *caption = [photo objectForKeyNotNull:@"text"];

  NSUInteger commentsCount = [[photo objectForKeyNotNull:@"comment_count"] intValue];
  NSString *mediaURL = [photo objectForKeyNotNull:@"media_url"];
  NSString *mediaType  = [photo objectForKeyNotNull:@"media_type"];
  
  if ([mediaType isEqualToString:@"photo"]) {
    self.photoImageView.imageURL = [NSURL URLWithString:mediaURL];
  }
  
  commentsCount = 1000;
  
  self.commentCountLabel.text = [NSString stringWithFormat:@"%d",commentsCount];
  CGSize commentCountLabelSize = [self.commentCountLabel.text sizeWithFont:self.commentCountLabel.font];
  self.commentCountLabel.frame = CGRectMake(self.commentCountLabel.frame.origin.x, 
                                            self.commentCountLabel.frame.origin.y, 
                                            commentCountLabelSize.width, 
                                            self.commentCountLabel.frame.size.height);
  self.commentCountIcon.frame = CGRectMake(self.commentCountLabel.frame.origin.x+self.commentCountLabel.frame.size.width, 
                                           self.commentCountIcon.frame.origin.y,
                                           self.commentCountIcon.frame.size.width, 
                                           self.commentCountIcon.frame.size.height);
  
  self.captionLabel.numberOfLines = 0;
  self.captionLabel.lineBreakMode = UILineBreakModeWordWrap;
  self.captionLabel.text = caption;
  
  if ([mediaType isEqualToString:@"photo"]) {
    self.photoImageView.frame = CGRectMake(10, self.captionLabel.frame.size.height, 300, 300);
  }
  else {
    self.photoImageView.frame = CGRectMake(10, self.captionLabel.frame.size.height, 300, 0);
  }
  self.actionBar.frame = CGRectMake(0, self.captionLabel.frame.size.height+self.photoImageView.frame.size.height , 320, self.actionBar.frame.size.height);
  
  
  NSArray *comments = [photo objectForKeyNotNull:@"comments"];
  [self setComments:comments];
}


-(IBAction)commentButtonPressed:(UIButton *)sender {
  NSString *photoID = [self.photo objectForKeyNotNull:@"id"];
  
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/posts/%@/comments",API_BASE,photoID]];
  PBCommentListViewController *vc = [[PBCommentListViewController alloc] initWithNibName:@"PBCommentListViewController" bundle:nil];
  vc.url = url;
  vc.hidesBottomBarWhenPushed = YES;
  [tableViewController.navigationController pushViewController:vc animated:YES];
  [vc release];
  return;
  if (_followingRequest) {
    [_followingRequest cancel];
    [_followingRequest release];
    _followingRequest = nil;
  }
}



-(IBAction)actionButtonPressed:(id)sender {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Flag Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Flag Post", nil];
  actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
  [actionSheet showFromTabBar:tableViewController.tabBarController.tabBar];
  [actionSheet release];
  
}

#pragma mark UIACtionSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{} // before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{}  // after animation

#pragma mark OHAtt
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo {
  NSUInteger index = [[[linkInfo URL] absoluteString] intValue];
  NSDictionary *comment = [[self.photo objectForKeyNotNull:@"comments"] objectAtIndex:index];
  
  NSString *userID = [[[comment objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"user"] objectForKeyNotNull:@"id"];
  
  
  PBStreamViewController *vc = [[PBStreamViewController alloc] initWithNibName:@"PBStreamViewController" bundle:nil];
  vc.navigationItem.title = @"xxx";
  vc.baseURL = [NSString stringWithFormat:@"http://%@/api/users/%@/posts",API_BASE,userID];
  vc.shouldShowFollowingBar = YES;
  vc.shouldShowProfileHeader = YES;
  vc.shouldShowProfileHeaderBeforeNetworkLoad = YES;
  vc.pullsToRefresh = YES;
  [self.tableViewController.navigationController pushViewController:vc animated:YES];
  // vc.navigationItem.title = [user objectForKeyNotNull:@"screen_name"];
  
  [vc release];
  
  return NO;
}

@end
