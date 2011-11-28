//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVBezierCurve.h"

@interface TVCubicBezierCurve : TVBezierCurve {
	CGPoint ctrl1, ctrl2;
}

+(TVCubicBezierCurve *)cubicCurveWithStart:(CGPoint)start controlPoint1:(CGPoint)control1 controlPoint2:(CGPoint)control2 end:(CGPoint)end;
-(id)initWithStart:(CGPoint)start controlPoint1:(CGPoint)control1 controlPoint2:(CGPoint)control2 end:(CGPoint)end;

@end
