//
//  PBCommentListViewController.h
//  PicBounce2
//
//  Created by BradSmith on 2/24/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"

@interface PBCommentListViewController : UIViewController {
  
  IBOutlet MyView *myView;
  
  IBOutlet UITableView *tableView;
  
  CGFloat keyboardHeight;
  
}

@end
