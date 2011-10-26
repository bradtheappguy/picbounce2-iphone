//
//  PBSharingOptionViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "PBProgressHUD.h"
@interface PBSharingOptionViewController : UIViewController < UITableViewDataSource, UITableViewDelegate, FBSessionDelegate > {
    
    UITableView *tableView;
    NSMutableArray *a_OptionArray;
    Facebook *facebook;
    BOOL isTwitterLogut;
}
@property (nonatomic, retain) PBProgressHUD *progressHUD;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *a_OptionArray;
@property (nonatomic, retain) NSMutableArray *facebookPages;
@end
