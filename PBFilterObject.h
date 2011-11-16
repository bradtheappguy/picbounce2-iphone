//
//  PBFilterObject.h
//  PicBounce2
//
//  Created by Thomas DiZoglio on 11/13/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBFilterNotifierDelegate.h"


@interface PBFilterObject : NSObject {
  
  NSString *filterName;
  NSArray *actions;

  UIButton *filterApplyButton;

}

@property (nonatomic, retain) NSString *filterName;
@property (nonatomic, retain) NSArray *actions;

- (UIButton *) createFilterButton;

@end
