//
//  FriendListView.h
//  PicBounce2
//
//  Created by Sunil on 5/2/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendListView : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *frendlistTable;
    
    NSArray *Contactlist;
    NSArray *Suggestlist;
    
    
}

@end
