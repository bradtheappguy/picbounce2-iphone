//
//  PBSharingOptionViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "PBProgressHUD.h"
#import "PBNavigationBar.h"
#import "ModalDismissDelegate.h"

typedef enum {
  kTwitterLoginCell = 0,
  kFaceBookLoginCell = 1,
  kFacebookWallCell = 2,
  kFacebookPagesCell = 3
  
} tvCellType;

@interface PBSharingOptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FBSessionDelegate ,FBRequestDelegate> {

  UITableView *tableView;
  UIButton *currStatusButtons;
  BOOL isTwitterLogut;
  IBOutlet PBNavigationBar *navBar;
  id<ModalDismissDelegate> delegate;
}

@property (nonatomic, retain) PBProgressHUD *progressHUD;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *facebookPages;
@property (nonatomic, retain) NSMutableDictionary *facebookWall;
@property (nonatomic, assign) id<ModalDismissDelegate> delegate;

- (IBAction)dismissModalViewControllerAnimated;
- (void)calculateSizeOfTable;

@end
