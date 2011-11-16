//
//  PBFilterNotifierDelegate.h
//  PicBounce2
//
//  Created by Thomas DiZoglio on 11/13/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PBFilterNotifierDelegate <NSObject>
@optional

/**
 * Called when the filter is done processing and the view needs to be updated.
 */
- (void)filterProcessingCompleteRefreshView:(UIImage *)image;

@end
