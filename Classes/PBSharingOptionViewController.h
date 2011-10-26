//
//  PBSharingOptionViewController.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface PBSharingOptionViewController : UIViewController < UITableViewDataSource, UITableViewDelegate, FBSessionDelegate > {
    
    UITableView *a_OptionsTableView;
    NSMutableArray *a_OptionArray;
    Facebook *facebook;
}
@property (nonatomic, retain) IBOutlet UITableView *a_OptionsTableView;
@property (nonatomic, retain) NSMutableArray *a_OptionArray;
@end
