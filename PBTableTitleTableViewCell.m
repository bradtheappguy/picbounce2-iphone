//
//  TableTitleTableViewCell.m
//
//  Created by BradSmith on 2/23/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBTableTitleTableViewCell.h"

@implementation PBTableTitleTableViewCell
@synthesize textLabel;

-(void) dealloc {
  self.textLabel = nil;
  [super dealloc];
}
@end
