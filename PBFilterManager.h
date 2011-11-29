//
//  PBFilterManager.h
//  PicBounce2
//
//  Created by Thomas DiZoglio on 11/13/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBNewFilterViewController.h"
#import "PBFilterObject.h"


#define FILTER_INFO_FILENAME  @"filter_v"
#define FILTERS_FILENAME  @"filters"
#define FILTER_DATA_DIRECTORY @"filter_data"

@interface PBFilterManager : NSObject {

  PBNewFilterViewController *parentViewController;
  id<PBFilterNotifierDelegate> delegate;

  NSDictionary *filterInformation;

  NSMutableArray *filterObjects;

  UIImage *cleanImage;
}

@property (nonatomic, retain) UIViewController *parentViewController;
@property (nonatomic, retain) id<PBFilterNotifierDelegate> delegate;


- (id) init:(PBNewFilterViewController *)parentView;

// Loads latest filter plist and create filter objects
- (BOOL) loadFilterPList;

// Layout the filter interface in the parent view
- (CGFloat) layoutFilterView:(UIScrollView *)view;

- (UIImage *) applyFilter:(int)index withImage:(UIImage *)image;

+ (void) createInitialScriptPListFiles;

- (NSMutableArray *) loadFilterDataFromPlist:(NSString *) filename;
- (NSDictionary *) loadFilterVersionFromPlist:(NSString *) filename;

- (void) storeFilterPlistFiles;

// Compares current filter plist version with that on the server and returns
// YES - updated filter plist from server
// NO - latest version local already
- (BOOL) updateFilterPlist;

// This makes sure all generic filter images used for buttons are created and cached.
// It updates the plist to the cahce file path. If reload is YES will force reload again.
// Retuns:
// YES - Successfully created local images for buttons and updated file paths in plist
// NO - failed to create filter images and update plist
+ (BOOL) createFilterButtonImages:(BOOL)reload;

- (UIImage *) createCleanImageFilter:(UIImage *)originalImage;

- (void) filterButtonPressed:(id)sender;

@end
