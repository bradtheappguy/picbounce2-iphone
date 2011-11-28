//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface TVSpline : NSObject {
	NSMutableArray *curves;
	CGPoint begin;
	CGPoint current;
}

// Initialization methods - start a spline at a particular point.
+(TVSpline *)splineAtPoint:(CGPoint)start;
-(id)initAtPoint:(CGPoint)start;

// Add a linear bezier curve (i.e. a line segment) to the spline, starting at the previous endpoint.
-(void)addLinearCurveToPoint:(CGPoint)end;

// Add a cubic bezier curve to the spline, starting at the previous endpoint.
-(void)addCubicCurveWithControl1:(CGPoint)ctrl1 control2:(CGPoint)ctrl2 toPoint:(CGPoint)end;

// Add a quadratic bezier curve to the spline, starting at the previous endpoint.
-(void)addQuadCurveWithControl:(CGPoint)ctrl toPoint:(CGPoint)end;

// Pop the most recently-added curve off the end of the spline.
-(void)removeLastCurve;

// Return an array of NSValues representing CGPoints dividing the spline into near-linear segments.
-(NSArray *)asPointArray;
@end
