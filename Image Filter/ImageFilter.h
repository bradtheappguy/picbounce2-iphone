//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    CurveChannelNone                 = 0,
    CurveChannelRed					 = 1 << 0,
    CurveChannelGreen				 = 1 << 1,
    CurveChannelBlue				 = 1 << 2,
};
typedef NSUInteger CurveChannel;

@interface UIImage (ImageFilter)

/* Filters */
- (UIImage*) greyscale;
- (UIImage*) sepia;
- (UIImage*) posterize:(int)levels;
- (UIImage*) saturate:(double)amount;
- (UIImage*) brightness:(double)amount;
- (UIImage*) gamma:(double)amount;
- (UIImage*) opacity:(double)amount;
- (UIImage*) contrast:(double)amount;
- (UIImage*) bias:(double)amount;

/* Color Correction */
- (UIImage*) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white;
- (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel;
- (UIImage*) adjust:(double)r g:(double)g b:(double)b;

/* Convolve Operations */
- (UIImage*) sharpen;
- (UIImage*) edgeDetect;
- (UIImage*) gaussianBlur:(NSUInteger)radius;
- (UIImage*) vignette;
- (UIImage*) darkVignette;
- (UIImage*) polaroidish;

/* Blend Operations */
- (UIImage*) overlay:(UIImage*)other;

/* Pre-packed filter sets */
- (UIImage*) lomo;

@end
