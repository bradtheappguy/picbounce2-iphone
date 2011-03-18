//
//  PBExploreViewController.h
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PBStreamViewController.h"

@interface PBExploreViewController : UIViewController {
  IBOutlet PBStreamViewController *firstViewController;
  IBOutlet PBStreamViewController *secondViewController;
  IBOutlet PBStreamViewController *thirdViewController;
}

-(IBAction) segmentedControlValueDidChange:(id)sender;

@end
