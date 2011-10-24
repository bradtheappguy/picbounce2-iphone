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
@synthesize photo = _photo;


+(CGFloat) heightWithPhoto:(NSDictionary *)photo {
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


  [super dealloc];
}


-(void) setPhoto:(NSDictionary *)photo {
  [_photo release];
  _photo = [photo retain];
 
        NSLog(@"%@",photo);
  NSString *caption = [photo objectForKey:@"caption"];
  
  NSString *photoID = [photo objectForKey:@"id"];
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
    [leaveCommentButton setAccessibilityHint:[photo objectForKeyNotNull:@"id"]];
  self.photoImageView.imageURL = [NSURL URLWithString:mediaURL];
  
  self.bounceCountLabel.text = [NSString stringWithFormat:@"%d",bouncesCount];
  self.commentCountLabel.text = [NSString stringWithFormat:@"%d",commentsCount];
  self.likeCountLabel.text = [NSString stringWithFormat:@"%d",likeCount];
  self.personCountLabel.text = [NSString stringWithFormat:@"%d",taggedPeopleCount];
  self.hashTagCountLabel.text = [NSString stringWithFormat:@"%d",tagsCount];
  
  
  if (![caption isEqual:[NSNull null]])
    self.commentLabel.text = caption;
  else
    self.commentLabel.text = @"";
}



-(IBAction)commentButtonPressed:(id)sender {
    UIButton *button = sender;
    NSString *userID = button.accessibilityHint;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingView" object:nil userInfo:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/posts/%@/comments",API_BASE,userID]];
    
    if (_followingRequest) {
        [_followingRequest cancel];
        [_followingRequest release];
        _followingRequest = nil;
    }
    _followingRequest = [[PBHTTPRequest requestWithURL:url] retain];
    _followingRequest.requestMethod = @"GET";
    _followingRequest.delegate = self;
    [_followingRequest setDidFailSelector:@selector(followingRequestDidFail:)];
    [_followingRequest setDidFinishSelector:@selector(followingRequestDidFinish:)];
    [_followingRequest startAsynchronous];
    

}
-(void) followingRequestDidFail:(ASIHTTPRequest *)followingRequest {
    
}

-(void) followingRequestDidFinish:(ASIHTTPRequest *)followingRequest {
    if (followingRequest.responseStatusCode == 200) {
            // NSLog(@"%@",followingRequest.responseString);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[followingRequest.responseString JSONValue]];
            // NSLog(@"%@",[[[dict valueForKey:@"response"] valueForKey:@"post"] valueForKey:@"id"]  );
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideLoadingView" object:nil userInfo:nil];
        PBCommentListViewController *vc = [[PBCommentListViewController alloc] initWithNibName:@"PBCommentListViewController" bundle:nil];
        vc.a_IDString = [[[dict valueForKey:@"response"] valueForKey:@"post"] valueForKey:@"id"];
        vc.a_CommentsArray = [[[dict valueForKey:@"response"] valueForKey:@"comments"] valueForKey:@"items"];
        vc.hidesBottomBarWhenPushed = YES;
        [tableViewController.navigationController pushViewController:vc animated:YES];
        [vc release];
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

@end
