//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "TVLinearBezierCurve.h"


@implementation TVLinearBezierCurve

+(TVLinearBezierCurve *)linearCurveWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
	return [[[TVLinearBezierCurve alloc] initWithStartPoint:start endPoint:end] autorelease];
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
	TVLinearBezierCurve *curve1 = [[TVLinearBezierCurve alloc] initWithStartPoint:p1 endPoint:mid];
	TVLinearBezierCurve *curve2 = [[TVLinearBezierCurve alloc] initWithStartPoint:mid endPoint:p2];
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
