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
#import "OHAttributedLabel.h"
#import "PBStreamViewController.h"
    //#define PhotoCellHeight 363

#define PhotoCellHeight 385
#define PhotoCellHeight 500

@implementation PBPhotoCell
@synthesize tableViewController;
@synthesize viewCountLabel;
@synthesize bounceCountLabel;
@synthesize bounceButton;
@synthesize photoImageView;
@synthesize commentLabel;
@synthesize commentCountLabel;
@synthesize leaveCommentButton;
@synthesize commentPreview;
@synthesize personCountLabel;
@synthesize hashTagCountLabel;
@synthesize likeCountLabel;
@synthesize photo = _photo;


+ (CGFloat) heightWithPhoto:(NSDictionary *)photo {
  return PhotoCellHeight;
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
    self.viewCountLabel = nil;
    self.bounceCountLabel = nil;
    self.bounceButton = nil;
    self.photoImageView = nil;
    self.commentLabel = nil;
    self.commentCountLabel = nil;
    self.leaveCommentButton = nil;
    
    
  [commentPreview release];
    [super dealloc];
}



-(void) setComments:(NSArray *)comments {
  NSMutableString *comment = [[NSMutableString alloc] initWithString:@"no comments right now"];
  if ([comments count] > 0) {
    comment = [(NSMutableString *) [NSMutableString alloc] initWithString:@""];
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
  
  OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
  label.linkColor = [UIColor blueColor];
  label.delegate = self;
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
  
  self.commentPreview = label;
  [self addSubview:self.commentPreview];
  label.font = [UIFont systemFontOfSize:14];
  label.textColor = [UIColor darkGrayColor];
  label.lineBreakMode = UILineBreakModeWordWrap;
  label.numberOfLines = 0;
  [label setAttributedText:attString];
  [label addCustomLink:[NSURL URLWithString:@"1"] inRange:NSMakeRange(0, 5)];
  /*
  [self.commentPreview setText:comment afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
    
    UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14]; 
    CTFontRef boldFont = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    
    int pos = 0;
    for (NSDictionary *c in comments) {
      NSString *name = [[[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"user"] objectForKeyNotNull:@"name"];
      NSString *text = [[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"text"];
      if (!text) {
        text = @"Blank Comment";
      }
      if ([text length] < 10) {
        text = [text stringByAppendingString:@" (Short Comment)"];
      }
      NSURL *url = [NSURL URLWithString:@"http://google.com"];
      [self.commentPreview addLinkToURL:url withRange:NSMakeRange(pos, [name length])];
      [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)boldFont range:NSMakeRange(pos, [name length])];
      pos += [name length] + 2 + [text length];
    }
    
    CFRelease(boldFont);
    return mutableAttributedString;
  }];      
  */
  //[self.commentPreview setDelegate:self]; 
  
  
  
  CGFloat height = 100.0f;
  //height += [attString sizeCon
  label.frame = CGRectMake(10, 395, 300, height);
}


/*-(void) setCommentsUsingOldWay:(NSArray *)comments {
  NSMutableString *comment = [[NSMutableString alloc] initWithString:@"no comments right now"];
  
  if ([comments count] > 0) {
    comment = [(NSMutableString *) [NSMutableString alloc] initWithString:@""];
  }
  
  for (NSDictionary *c in comments) {
    NSString *name = [[[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"user"] objectForKeyNotNull:@"name"];
    NSString *text = [[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"text"];
    if (!text) {
      text = @"Blank Comment";
    }
    if ([text length] < 10) {
      text = [text stringByAppendingString:@" (Short Comment)"];
    }
    [comment appendString:name];
    [comment appendString:@" "];
    [comment appendString:text];
    [comment appendString:@"\n"];
  }
  
  
  self.commentPreview = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
  
  [self addSubview:self.commentPreview];
  self.commentPreview.font = [UIFont systemFontOfSize:14];
  self.commentPreview.textColor = [UIColor darkGrayColor];
  self.commentPreview.lineBreakMode = UILineBreakModeWordWrap;
  self.commentPreview.numberOfLines = 0;
  
  NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
  [mutableLinkAttributes setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCTUnderlineStyleAttributeName];
  self.commentPreview.linkAttributes = mutableLinkAttributes;
  
  
  [self.commentPreview setText:comment afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
    
    UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14]; 
    CTFontRef boldFont = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    
    int pos = 0;
    for (NSDictionary *c in comments) {
      NSString *name = [[[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"user"] objectForKeyNotNull:@"name"];
      NSString *text = [[c objectForKeyNotNull:@"comment"] objectForKeyNotNull:@"text"];
      if (!text) {
        text = @"Blank Comment";
      }
      if ([text length] < 10) {
        text = [text stringByAppendingString:@" (Short Comment)"];
      }
      NSURL *url = [NSURL URLWithString:@"http://google.com"];
      [self.commentPreview addLinkToURL:url withRange:NSMakeRange(pos, [name length])];
      [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)boldFont range:NSMakeRange(pos, [name length])];
      pos += [name length] + 2 + [text length];
    }
    
    CFRelease(boldFont);
    return mutableAttributedString;
  }];      
  
  [self.commentPreview setDelegate:self]; 
  
  
  
  CGFloat height = 10.0f;
  height += ceilf([comment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
  self.commentPreview.frame = CGRectMake(10, 395, 300, height);
}*/



-(void) setPhoto:(NSDictionary *)photo {
    [_photo release];
    _photo = [photo retain];
    
    NSString *caption = [photo objectForKey:@"text"];
    
    NSString *twitter_avatar_url = [photo objectForKey:@"avatar"];
    if ([twitter_avatar_url isEqual:[NSNull null]]) {
        twitter_avatar_url = nil;
    }
    
    NSUInteger likeCount = [[photo objectForKey:@"likes_count"] intValue];
    NSUInteger bouncesCount = [[photo objectForKey:@"bounces_count"] intValue];
    NSUInteger commentsCount = [[photo objectForKey:@"comments_count"] intValue];
    NSUInteger taggedPeopleCount = [[photo objectForKey:@"tagged_people_count"] intValue];
    NSUInteger tagsCount = [[photo objectForKey:@"tags_count"] intValue];
    NSString *mediaURL = [photo objectForKeyNotNull:@"media_url"];
    NSString *mediaType  = [photo objectForKeyNotNull:@"media_type"];

  if ([mediaType isEqualToString:@"photo"]) {
    self.photoImageView.imageURL = [NSURL URLWithString:mediaURL];
  }
    
    
    self.bounceCountLabel.text = [NSString stringWithFormat:@"%d",bouncesCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d",commentsCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",likeCount];
    self.personCountLabel.text = [NSString stringWithFormat:@"%d",taggedPeopleCount];
    self.hashTagCountLabel.text = [NSString stringWithFormat:@"%d",tagsCount];
    
    
    if (![caption isEqual:[NSNull null]])
        self.commentLabel.text = caption;
    else
        self.commentLabel.text = @"";
  
  NSArray *comments = [photo objectForKeyNotNull:@"comments"];
  [self setComments:comments];
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  NSLog(@"link");
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
