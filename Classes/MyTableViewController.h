//
//  MyTableViewController.h
//  PathBoxes
//
//  Created by Brad Smith on 11/24/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PBRootViewController.h"

@interface MyTableViewController : PBRootViewController {

  
  BOOL showProfileHeader;
  
  IBOutlet UITableViewCell *headerCell;
}

-(void) loadFromCache;

@property (nonatomic, retain) IBOutlet UITableViewCell *headerCell;

@property (readwrite) BOOL showProfileHeader;
@end
