//
//  PBExploreViewController.m
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBExploreViewController.h"

@implementation PBExploreViewController

-(void) viewDidLoad {
  [self.navigationController popViewControllerAnimated:NO];
  [self.navigationController pushViewController:firstViewController animated:NO]; 
}

-(IBAction) segmentedControlValueDidChange:(UISegmentedControl *)sender {
  [self.navigationController popViewControllerAnimated:NO];
  if (sender.selectedSegmentIndex == 0) {
    
    [self.navigationController pushViewController:firstViewController animated:NO]; 
   firstViewController.segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex;
  }
  if (sender.selectedSegmentIndex == 1) {
    
    [self.navigationController pushViewController:secondViewController animated:NO]; 
    secondViewController.segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex;
  }
  if (sender.selectedSegmentIndex == 2) {
  
    [self.navigationController pushViewController:thirdViewController animated:NO]; 
      thirdViewController.segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex;
  }
}
@end
