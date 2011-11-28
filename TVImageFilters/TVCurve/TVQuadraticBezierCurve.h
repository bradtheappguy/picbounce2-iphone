//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TVBezierCurve.h"

@interface TVQuadraticBezierCurve : TVBezierCurve {
	CGPoint ctrl;
}

+(TVQuadraticBezierCurve *)quadraticCurveWithStartPoint:(CGPoint)start controlPoint:(CGPoint)control endPoint:(CGPoint)end;
-(id)initWithStartPoint:(CGPoint)start controlPoint:(CGPoint)control endPoint:(CGPoint)end;

@end
