//
//  VenueViewController.h
//  PathBoxes
//
//  Created by BradSmith on 2/19/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PBRootViewController.h"


@interface VenueViewController : PBRootViewController {
  
  BOOL showProfileHeader;
  
  IBOutlet UITableViewCell *headerCell;
  
  
}


-(void) loadMockData;

@property (nonatomic, retain) IBOutlet UITableViewCell *headerCell;

@property (readwrite) BOOL showProfileHeader;
@end
