//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "TVBezierCurve.h"


@implementation TVBezierCurve
@synthesize p1, p2;

- (NSArray *)subdivided {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (BOOL)isNearLinear {
	[self doesNotRecognizeSelector:_cmd];
	return NO;
}

- (NSArray *)asPointArray {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (void)addToPointArray:(NSMutableArray *)pointArray {
	[self doesNotRecognizeSelector:_cmd];
}

@end
