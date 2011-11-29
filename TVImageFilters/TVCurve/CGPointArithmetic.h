//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <math.h>

#define CGPointDifference(p1,p2)	(CGPointMake(((p1.x) - (p2.x)), ((p1.y) - (p2.y))))
#define CGPointMagnitude(p)			sqrt(p.x*p.x + p.y*p.y)
#define CGPointSlope(p)				(p.y / p.x)
#define CGPointScale(p, d)			CGPointMake(p.x * d, p.y * d)
#define CGPointAdd(p1, p2)			CGPointMake(p1.x + p2.x, p1.y + p2.y)
#define CGPointMidpoint(p1, p2)		CGPointMake((p1.x + p2.x)/2., (p1.y + p2.y)/2.)