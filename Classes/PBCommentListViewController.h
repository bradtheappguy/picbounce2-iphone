//
//  PBCommentListViewController.h
//  PicBounce2
//
//  Created by BradSmith on 2/24/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"
#import "PBRootViewController.h"
#import "ASIHTTPRequest.h"
#import "PBProgressHUD.h"

@interface PBCommentListViewController :UIViewController {
  
  IBOutlet MyView *myView;
  
  IBOutlet UITableView *tableView;
  
  CGFloat keyboardHeight;
    
  NSMutableArray *comments;
  
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSMutableArray *uploadedComments;
@property (nonatomic, retain) NSMutableArray *comments;
@property (nonatomic, retain) NSString *postID;
@property (nonatomic, retain) PBProgressHUD *progressHUD;
@property (nonatomic, retain) ASIHTTPRequest *postCommentRequest;
@property (nonatomic, retain) ASIHTTPRequest *getCommentsRequest;

- (void) moveViewsForKeyboard:(NSNotification*)aNotification up: (BOOL) up;
- (void) downViewsForKeyboard:(NSNotification*)aNotification down: (BOOL) up;
@end
