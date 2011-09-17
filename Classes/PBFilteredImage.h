//
//  PBFilteredImage.h
//  test22
//
//  Created by Brad Smith on 15/09/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBFilteredImage : NSObject

+ (UIImage *) filteredImageWithImage:(UIImage *)image filter:(NSString *)filterName;

+ (NSArray *) availableFilters;
@end
