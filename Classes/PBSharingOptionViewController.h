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


@interface PBSharingOptionViewController : UIViewController < UITableViewDataSource, UITableViewDelegate, FBSessionDelegate ,FBRequestDelegate > {
    
    UITableView *tableView;
    NSMutableArray *a_OptionArray;
    Facebook *facebook;
    BOOL isTwitterLogut;
    IBOutlet PBNavigationBar *navBar;
    id<ModalDismissDelegate> delegate;
}
@property (nonatomic, retain) PBProgressHUD *progressHUD;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *a_OptionArray;
@property (nonatomic, retain) NSMutableArray *facebookPages;
@property (nonatomic, assign) id<ModalDismissDelegate> delegate;
- (IBAction)dismissModalViewControllerAnimated;
- (void)makeSizeOfTable;
@end
