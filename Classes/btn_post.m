//
//	btn_post.m
//	Post Button
//
//	Created by Max Harris on 3/25/11
//	Copyright Like Thought, LLC. All rights reserved.
//	THIS CODE IS FOR EVALUATION ONLY. YOU MAY NOT USE IT FOR ANY OTHER PURPOSE UNLESS YOU PURCHASE A LICENSE FOR OPACITY.
//

#import "btn_post.h"

const CGFloat kBlueButtonBackgroundWidth = 115.0f;
const CGFloat kBlueButtonBackgroundHeight = 50.0f;

@implementation BlueButtonBackground


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setOpaque:NO];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setOpaque:NO];
	}
	return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return CGSizeMake(kBlueButtonBackgroundWidth, kBlueButtonBackgroundHeight);
}

- (void)drawRect:(CGRect)dirtyRect
{
	CGRect imageBounds = CGRectMake(0.0f, 0.0f, kBlueButtonBackgroundWidth, kBlueButtonBackgroundHeight);
	CGRect bounds = [self bounds];
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor *color;
	CGFloat resolution;
	CGFloat alignStroke;
	CGFloat stroke;
	CGMutablePathRef path;
	CGPoint point;
	CGPoint controlPoint1;
	CGPoint controlPoint2;
	CGGradientRef gradient;
	NSMutableArray *colors;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGPoint point2;
	CGFloat locations[4];
	resolution = 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Setup for Shadow Effect
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.6f];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f * resolution, 1.0f * resolution), 0.0f * resolution, [color CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
	
	// Button Color
	
	stroke = 1.0f;
	stroke *= resolution;
	if (stroke < 1.0f) {
		stroke = ceilf(stroke);
	} else {
		stroke = roundf(stroke);
	}
	stroke /= resolution;
	alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
	path = CGPathCreateMutable();
	point = CGPointMake(106.5f, 49.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(114.5f, 41.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(110.889f, 49.5f);
	controlPoint2 = CGPointMake(114.5f, 45.889f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(114.5f, 8.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(106.5f, 0.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(114.5f, 4.111f);
	controlPoint2 = CGPointMake(110.889f, 0.5f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(8.5f, 0.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(0.5f, 8.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(4.111f, 0.5f);
	controlPoint2 = CGPointMake(0.5f, 4.111f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(0.5f, 41.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(8.5f, 49.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(0.5f, 45.889f);
	controlPoint2 = CGPointMake(4.111f, 49.5f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(106.5f, 49.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	CGPathCloseSubpath(path);
	color = [UIColor colorWithRed:0.06f green:0.383f blue:0.907f alpha:1.0f];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	color = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.0f];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	// Button Shine
	
	stroke = 1.0f;
	stroke *= resolution;
	if (stroke < 1.0f) {
		stroke = ceilf(stroke);
	} else {
		stroke = roundf(stroke);
	}
	stroke /= resolution;
	alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
	path = CGPathCreateMutable();
	point = CGPointMake(106.5f, 49.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(114.5f, 41.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(110.889f, 49.5f);
	controlPoint2 = CGPointMake(114.5f, 45.889f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(114.5f, 8.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(106.5f, 0.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(114.5f, 4.111f);
	controlPoint2 = CGPointMake(110.889f, 0.5f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(8.5f, 0.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(0.5f, 8.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(4.111f, 0.5f);
	controlPoint2 = CGPointMake(0.5f, 4.111f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(0.5f, 41.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(8.5f, 49.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(0.5f, 45.889f);
	controlPoint2 = CGPointMake(4.111f, 49.5f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(106.5f, 49.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	CGPathCloseSubpath(path);
	colors = [NSMutableArray arrayWithCapacity:4];
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
	[colors addObject:(id)[color CGColor]];
	locations[0] = 1.0f;
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
	[colors addObject:(id)[color CGColor]];
	locations[1] = 0.75f;
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
	[colors addObject:(id)[color CGColor]];
	locations[2] = 0.5f;
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.6f];
	[colors addObject:(id)[color CGColor]];
	locations[3] = 0.02f;
	gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	point = CGPointMake(57.5f, 0.5f);
	point2 = CGPointMake(57.5f, 49.5f);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	color = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.6f];
	[color setStroke];
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	// Shadow Effect
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
	
	CGContextRestoreGState(context);
	CGColorSpaceRelease(space);
}

@end
