//
//  PBExploreViewController.h
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PBProfileViewController.h"

@interface PBExploreViewController : UIViewController {
  IBOutlet PBProfileViewController *firstViewController;
  IBOutlet PBProfileViewController *secondViewController;
  IBOutlet PBProfileViewController *thirdViewController;
}

-(IBAction) segmentedControlValueDidChange:(id)sender;

@end
