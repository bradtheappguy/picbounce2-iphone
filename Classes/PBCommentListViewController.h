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

@interface PBCommentListViewController :UIViewController {
  
  IBOutlet MyView *myView;
  
  IBOutlet UITableView *tableView;
  
  CGFloat keyboardHeight;
    
NSMutableArray *a_CommentsArray;
  ASIHTTPRequest *_followingRequest;
}
@property (nonatomic, retain) NSMutableArray *a_CommentsArray;
@property (nonatomic, retain) NSString *a_IDString;
- (void) moveViewsForKeyboard:(NSNotification*)aNotification up: (BOOL) up;
- (void) downViewsForKeyboard:(NSNotification*)aNotification down: (BOOL) up;
@end
