//
//  QuadraticBezierCurve.h
//  Curve
//
//  
//

#import <Foundation/Foundation.h>
#import "BezierCurve.h"

@interface QuadraticBezierCurve : BezierCurve {
	CGPoint ctrl;
}

+(QuadraticBezierCurve *)quadraticCurveWithStartPoint:(CGPoint)start controlPoint:(CGPoint)control endPoint:(CGPoint)end;
-(id)initWithStartPoint:(CGPoint)start controlPoint:(CGPoint)control endPoint:(CGPoint)end;

@end
