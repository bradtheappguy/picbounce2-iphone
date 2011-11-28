//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface TVBezierCurve : NSObject {
	CGPoint p1, p2;
}

// Start point
@property (nonatomic, readonly) CGPoint p1;
// End point
@property (nonatomic, readonly) CGPoint p2;

// An array of two Bezier curves of the same degree as the original.
// These two curves, placed together, encompass exactly the same points
// as the original.
-(NSArray *)subdivided;

// Returns whether the curve may be treated as linear for drawing or other purposes.
-(BOOL)isNearLinear;

// Returns an array of NSValues representing CGPoints dividing the curve into near-linear subsections.
-(NSArray *)asPointArray;

// The same as asPointArray, but adds points to an existing array for efficiency.
-(void)addToPointArray:(NSMutableArray *)pointArray;
@end
