//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "LinearBezierCurve.h"


@implementation LinearBezierCurve

+(LinearBezierCurve *)linearCurveWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
	return [[[LinearBezierCurve alloc] initWithStartPoint:start endPoint:end] autorelease];
}

-(id)initWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
	if (self = [super init]) {
		p1 = start;
		p2 = end;
	}
	return self;
}

-(BOOL)isNearLinear {
	return YES;
}

-(NSArray *)subdivided {
	CGPoint mid = CGPointMake((p1.x + p2.x)/2, (p1.y + p2.y)/2);
	LinearBezierCurve *curve1 = [[LinearBezierCurve alloc] initWithStartPoint:p1 endPoint:mid];
	LinearBezierCurve *curve2 = [[LinearBezierCurve alloc] initWithStartPoint:mid endPoint:p2];
	NSArray *result = [NSArray arrayWithObjects:curve1, curve2, nil];
	[curve1 release];
	[curve2 release];
	
	return result;
}

-(NSArray *)asPointArray {
	return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2], nil];
}

-(void)addToPointArray:(NSMutableArray *)pointArray {
	[pointArray addObject:[NSValue valueWithCGPoint:p1]];
}
@end
