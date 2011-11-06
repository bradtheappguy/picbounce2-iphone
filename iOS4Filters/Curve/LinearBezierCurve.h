//
//  LinearBezierCurve.h
//  Curve
//
//  
//

#import <Foundation/Foundation.h>
#import "BezierCurve.h"

@interface LinearBezierCurve : BezierCurve {
}

+(LinearBezierCurve *)linearCurveWithStartPoint:(CGPoint)start endPoint:(CGPoint)end;
-(id)initWithStartPoint:(CGPoint)start endPoint:(CGPoint)end;

@end
