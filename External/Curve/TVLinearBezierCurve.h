//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TVBezierCurve.h"

@interface TVLinearBezierCurve : TVBezierCurve {
}

+(TVLinearBezierCurve *)linearCurveWithStartPoint:(CGPoint)start endPoint:(CGPoint)end;
-(id)initWithStartPoint:(CGPoint)start endPoint:(CGPoint)end;

@end
