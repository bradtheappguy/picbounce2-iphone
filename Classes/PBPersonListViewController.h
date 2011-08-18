//
//  PBPersonListViewController.h
//  PicBounce2
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBRootViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressbookUI.h>

@interface PBPersonListViewController : PBRootViewController {

    NSMutableArray *namelist;
    NSMutableArray *emailList;
    NSInteger sl;
  
  IBOutlet UITableViewCell *_cell; 

}

@property (nonatomic,readwrite) NSInteger sl;

@end
