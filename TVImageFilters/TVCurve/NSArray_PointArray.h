//
//  NSArray_PointArray.h
//  Curve
//
//	A category for NSArray, providing methods for extracting information from an array
//	of NSValues representing CGPoints.
//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

// A structure for extracting a subarray from the original array.
// start is the start point of the subarray
// end is the end point of the subarray
// startIndex is the index of the first point in the array that is contained by the subarray
// endIndex is the index of the first point in the array that is past the end of the subarray
struct PointArrayBounds {
	CGPoint start;
	CGPoint end;
	NSInteger startIndex;
	NSInteger endIndex;
};

// A structure for extracting a particular point from the array, along with the angle of the
// line segment containing that point.
struct PointArrayLocation {
	CGPoint location;
	CGFloat angle;
};

typedef struct PointArrayBounds PointArrayBounds;
typedef struct PointArrayLocation PointArrayLocation;

@interface NSArray(PointArray)

// Return the location and angle of a point at distance d along the curve represented by this array.
-(PointArrayLocation)locationAtDistance:(CGFloat)d;

// Return the total length of the curve represented by this array.
-(CGFloat)length;

// Return the information for a subcurve of the curve represented by this array.
-(PointArrayBounds)pointArrayBoundsFromDistance:(CGFloat)from to:(CGFloat)to;

@end
