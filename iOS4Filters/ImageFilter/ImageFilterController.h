//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Gaurav Goyal on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFilterController : NSObject

+ (UIImage *) filteredImageWithImage:(UIImage *)image filter:(int)filterCase;

@end
