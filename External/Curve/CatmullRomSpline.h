//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Spline.h"

@interface CatmullRomSpline : Spline {
	CGPoint p3, p2, p1, p;
}

+(CatmullRomSpline *)catmullRomSplineAtPoint:(CGPoint)start;

// Add a control point, through which the spline must pass, to the end of the spline.
-(void)addPoint:(CGPoint)point;

@end
