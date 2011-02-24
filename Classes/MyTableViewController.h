//
//  MyTableViewController.h
//  PathBoxes
//
//  Created by Brad Smith on 11/24/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

@interface MyTableViewController : RootViewController {

  
  BOOL showProfileHeader;
  
  IBOutlet UITableViewCell *headerCell;
}


-(void) loadMockData;

@property (nonatomic, retain) IBOutlet UITableViewCell *headerCell;

@property (readwrite) BOOL showProfileHeader;
@end
