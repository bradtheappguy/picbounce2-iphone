//
//  PBFilterObject.m
//  PicBounce2
//
//  Created by Thomas DiZoglio on 11/13/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBFilterObject.h"
#import "PBFilterManager.h"

@implementation PBFilterObject

@synthesize filterName;
@synthesize actions;


#pragma mark init / dealloc

- (id) init:(UIViewController *)parentView {
  
  if (self = [super init]) {
  }
  return self;
}

- (id) init {
  
  if (self = [super init]) {
    filterApplyButton = nil;
  }
  return self;
}

- (void)dealloc {
  
  [super dealloc];
  [filterApplyButton release];
}

- (UIButton *) createFilterButton {

  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docDirectory = [sysPaths objectAtIndex:0];
  NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@-cache.png", docDirectory, FILTER_DATA_DIRECTORY, filterName];
  if ([fileManager fileExistsAtPath:filePath]) {
    UIImage *gImage = [UIImage imageWithContentsOfFile:filePath];
    filterApplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[filterApplyButton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
    [filterApplyButton setImage:gImage forState:UIControlStateNormal];
    [filterApplyButton setTitle:filterName forState:UIControlStateNormal];
    filterApplyButton.frame = CGRectMake(0, 0, 80.0, 80.0);
  } else {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@", docDirectory, FILTER_DATA_DIRECTORY, @"generic_filter_image.png"];
    UIImage *gImage = [UIImage imageWithContentsOfFile:filePath];
    filterApplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[filterApplyButton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
    [filterApplyButton setImage:gImage forState:UIControlStateNormal];
    [filterApplyButton setTitle:filterName forState:UIControlStateNormal];
    filterApplyButton.frame = CGRectMake(0, 0, 80.0, 80.0);
  }

  return filterApplyButton;
}

@end
