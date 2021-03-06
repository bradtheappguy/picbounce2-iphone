//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageFilterForFrame;
@interface ImageFilterController : NSObject
{
    ImageFilterForFrame *imageFilterForFrame;
}
+ (UIImage *) filteredImageWithImage:(UIImage *)image filter:(int)filterCase;

@end
