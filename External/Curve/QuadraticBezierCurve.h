//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BezierCurve.h"

@interface QuadraticBezierCurve : BezierCurve {
	CGPoint ctrl;
}

+(QuadraticBezierCurve *)quadraticCurveWithStartPoint:(CGPoint)start controlPoint:(CGPoint)control endPoint:(CGPoint)end;
-(id)initWithStartPoint:(CGPoint)start controlPoint:(CGPoint)control endPoint:(CGPoint)end;

@end
