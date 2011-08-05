//
//	image@2x.m
//	New Image
//
//	Created by Ruth Martin on 8/4/11
//	Copyright Like Thought, LLC. All rights reserved.
//	THIS CODE IS FOR EVALUATION ONLY. YOU MAY NOT USE IT FOR ANY OTHER PURPOSE UNLESS YOU PURCHASE A LICENSE FOR OPACITY.
//

#import "image@2x.h"

const CGFloat kMyViewWidth = 150.0f;
const CGFloat kMyViewHeight = 100.0f;

@implementation MyView


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
	return CGSizeMake(kMyViewWidth, kMyViewHeight);
}

- (void)drawRect:(CGRect)dirtyRect
{
	CGRect imageBounds = CGRectMake(0.0f, 0.0f, kMyViewWidth, kMyViewHeight);
	CGRect bounds = [self bounds];
	CGContextRef context = UIGraphicsGetCurrentContext();
	size_t bytesPerRow;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	UIColor *color;
	CGFloat resolution;
	CGFloat alignStroke;
	CGMutablePathRef path;
	CGPoint point;
	CGPoint controlPoint1;
	CGPoint controlPoint2;
	CGRect drawRect;
	CGImageRef contextImage;
	CGRect effectBounds;
	unsigned char *pixels;
	CGFloat minX, maxX, minY, maxY;
	NSUInteger width, height;
	CGContextRef maskContext;
	CGImageRef maskImage;
	CGDataProviderRef provider;
	NSData *data;
	CGFloat stroke;
	NSString *string;
	UIFont *font;
	resolution = 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Setup for Inner Shadow Effect
	bytesPerRow = 4 * roundf(bounds.size.width);
	context = CGBitmapContextCreate(NULL, roundf(bounds.size.width), roundf(bounds.size.height), 8, bytesPerRow, space, kCGImageAlphaPremultipliedLast);
	UIGraphicsPushContext(context);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Setup for Inner Shadow Effect
	bytesPerRow = 4 * roundf(bounds.size.width);
	context = CGBitmapContextCreate(NULL, roundf(bounds.size.width), roundf(bounds.size.height), 8, bytesPerRow, space, kCGImageAlphaPremultipliedLast);
	UIGraphicsPushContext(context);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Setup for Shadow Effect
	color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f * resolution, 0.0f * resolution), 3.0f * resolution, [color CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
	
	// shadowCurved
	
	alignStroke = 0.0f;
	path = CGPathCreateMutable();
	point = CGPointMake(8.0f, 8.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(8.0f, 83.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(74.0f, 78.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(8.0f, 83.0f);
	controlPoint2 = CGPointMake(66.0f, 78.0f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(140.0f, 83.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(82.0f, 78.0f);
	controlPoint2 = CGPointMake(140.0f, 83.0f);
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(140.0f, 8.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(8.0f, 8.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	CGPathCloseSubpath(path);
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);
	
	// Shadow Effect
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
	
	// main
	
	alignStroke = 0.0f;
	path = CGPathCreateMutable();
	drawRect = CGRectMake(8.0f, 7.0f, 132.0f, 76.0f);
	drawRect.origin.x = (roundf(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
	drawRect.origin.y = (roundf(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	CGPathAddRect(path, NULL, drawRect);
	color = [UIColor colorWithRed:0.984f green:0.973f blue:0.969f alpha:1.0f];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);
	
	// Inner Shadow Effect
	pixels = (unsigned char *)CGBitmapContextGetData(context);
	width = roundf(bounds.size.width);
	height = roundf(bounds.size.height);
	minX = width;
	maxX = -1.0f;
	minY = height;
	maxY = -1.0f;
	for (NSInteger row = 0; row < height; row++) {
		for (NSInteger column = 0; column < width; column++) {
			if (pixels[4 * (width * row + column) + 3] > 0) {
				minX = MIN(minX, (CGFloat)column);
				maxX = MAX(maxX, (CGFloat)column);
				minY = MIN(minY, (CGFloat)(height - row));
				maxY = MAX(maxY, (CGFloat)(height - row));
			}
		}
	}
	contextImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIGraphicsPopContext();
	context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, imageBounds, contextImage);
	CGContextSetAlpha(context, 0.439f);
	CGContextBeginTransparencyLayer(context, NULL);
	if ((minX <= maxX) && (minY <= maxY)) {
		CGContextSaveGState(context);
		effectBounds = CGRectMake(minX, minY - 1.0f, maxX - minX + 1.0f, maxY - minY + 1.0f);
		effectBounds = CGRectInset(effectBounds, -(ABS(0.0f * cosf(1.501f) * resolution) + 100.0f), -(ABS(0.0f * sinf(1.501f) * resolution) + 100.0f));
		effectBounds = CGRectIntegral(effectBounds);
		color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
		CGContextSetShadowWithColor(context, CGSizeMake(0.0f * cosf(1.501f) * resolution, 0.0f * sinf(1.501f) * resolution - effectBounds.size.height), 100.0f, [color CGColor]);
		bytesPerRow = roundf(effectBounds.size.width);
		maskContext = CGBitmapContextCreate(NULL, roundf(effectBounds.size.width), roundf(effectBounds.size.height), 8, bytesPerRow, NULL, kCGImageAlphaOnly);
		CGContextDrawImage(maskContext, CGRectMake(-effectBounds.origin.x, -effectBounds.origin.y, bounds.size.width, bounds.size.height), contextImage);
		maskImage = CGBitmapContextCreateImage(maskContext);
		data = [NSData dataWithBytes:CGBitmapContextGetData(maskContext) length:bytesPerRow * roundf(effectBounds.size.height)];
		provider = CGDataProviderCreateWithCFData((CFDataRef)data);
		CGImageRelease(contextImage);
		contextImage = CGImageMaskCreate(roundf(effectBounds.size.width), roundf(effectBounds.size.height), 8, 8, bytesPerRow, provider, NULL, 0);
		CGDataProviderRelease(provider);
		CGContextRelease(maskContext);
		CGContextScaleCTM(context, (imageBounds.size.width / bounds.size.width), (imageBounds.size.height / bounds.size.height));
		CGContextClipToMask(context, effectBounds, maskImage);
		CGImageRelease(maskImage);
		effectBounds.origin.y += effectBounds.size.height;
		[[UIColor blackColor] setFill];
		CGContextDrawImage(context, effectBounds, contextImage);
		CGContextRestoreGState(context);
	}
	CGImageRelease(contextImage);
	
	CGContextEndTransparencyLayer(context);
	
	// Layer 1
	CGContextSetAlpha(context, 0.052f);
	CGContextBeginTransparencyLayer(context, NULL);
	
	alignStroke = 0.0f;
	path = CGPathCreateMutable();
	drawRect = CGRectMake(8.0f, 7.0f, 132.0f, 76.0f);
	drawRect.origin.x = (roundf(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
	drawRect.origin.y = (roundf(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	CGPathAddRect(path, NULL, drawRect);
	color = [UIColor colorWithRed:0.984f green:0.973f blue:0.969f alpha:1.0f];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);
	
	CGContextEndTransparencyLayer(context);
	
	// Inner Shadow Effect
	pixels = (unsigned char *)CGBitmapContextGetData(context);
	width = roundf(bounds.size.width);
	height = roundf(bounds.size.height);
	minX = width;
	maxX = -1.0f;
	minY = height;
	maxY = -1.0f;
	for (NSInteger row = 0; row < height; row++) {
		for (NSInteger column = 0; column < width; column++) {
			if (pixels[4 * (width * row + column) + 3] > 0) {
				minX = MIN(minX, (CGFloat)column);
				maxX = MAX(maxX, (CGFloat)column);
				minY = MIN(minY, (CGFloat)(height - row));
				maxY = MAX(maxY, (CGFloat)(height - row));
			}
		}
	}
	contextImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIGraphicsPopContext();
	context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, imageBounds, contextImage);
	CGContextSetAlpha(context, 0.87f);
	CGContextBeginTransparencyLayer(context, NULL);
	if ((minX <= maxX) && (minY <= maxY)) {
		CGContextSaveGState(context);
		effectBounds = CGRectMake(minX, minY - 1.0f, maxX - minX + 1.0f, maxY - minY + 1.0f);
		effectBounds = CGRectInset(effectBounds, -(ABS(2.0f * cosf(-2.88f) * resolution) + 2.0f), -(ABS(2.0f * sinf(-2.88f) * resolution) + 2.0f));
		effectBounds = CGRectIntegral(effectBounds);
		color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
		CGContextSetShadowWithColor(context, CGSizeMake(2.0f * cosf(-2.88f) * resolution, 2.0f * sinf(-2.88f) * resolution - effectBounds.size.height), 2.0f, [color CGColor]);
		bytesPerRow = roundf(effectBounds.size.width);
		maskContext = CGBitmapContextCreate(NULL, roundf(effectBounds.size.width), roundf(effectBounds.size.height), 8, bytesPerRow, NULL, kCGImageAlphaOnly);
		CGContextDrawImage(maskContext, CGRectMake(-effectBounds.origin.x, -effectBounds.origin.y, bounds.size.width, bounds.size.height), contextImage);
		maskImage = CGBitmapContextCreateImage(maskContext);
		data = [NSData dataWithBytes:CGBitmapContextGetData(maskContext) length:bytesPerRow * roundf(effectBounds.size.height)];
		provider = CGDataProviderCreateWithCFData((CFDataRef)data);
		CGImageRelease(contextImage);
		contextImage = CGImageMaskCreate(roundf(effectBounds.size.width), roundf(effectBounds.size.height), 8, 8, bytesPerRow, provider, NULL, 0);
		CGDataProviderRelease(provider);
		CGContextRelease(maskContext);
		CGContextScaleCTM(context, (imageBounds.size.width / bounds.size.width), (imageBounds.size.height / bounds.size.height));
		CGContextClipToMask(context, effectBounds, maskImage);
		CGImageRelease(maskImage);
		effectBounds.origin.y += effectBounds.size.height;
		[[UIColor blackColor] setFill];
		CGContextDrawImage(context, effectBounds, contextImage);
		CGContextRestoreGState(context);
	}
	CGImageRelease(contextImage);
	
	CGContextEndTransparencyLayer(context);
	
	// strokeLeftOut
	CGContextSetAlpha(context, 1.0f);
	
	// strokeTopTop
	
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
	point = CGPointMake(139.5f, 7.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(9.0f, 7.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	// strokeTopBtm
	
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
	point = CGPointMake(139.5f, 8.0f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(8.5f, 8.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.54f];
	[color setStroke];
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	// strokeTopTop
	CGContextSetAlpha(context, 0.752f);
	CGContextBeginTransparencyLayer(context, NULL);
	
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
	point = CGPointMake(8.5f, 8.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(8.5f, 82.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	[color setStroke];
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	CGContextEndTransparencyLayer(context);
	
	// strokeTopBtm
	CGContextBeginTransparencyLayer(context, NULL);
	
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
	point = CGPointMake(9.5f, 9.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(9.5f, 82.5f);
	point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.54f];
	[color setStroke];
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	CGContextEndTransparencyLayer(context);
	
	// text
	CGContextSetAlpha(context, 1.0f);
	
	// Setup for Inner Shadow Effect
	bytesPerRow = 4 * roundf(bounds.size.width);
	context = CGBitmapContextCreate(NULL, roundf(bounds.size.width), roundf(bounds.size.height), 8, bytesPerRow, space, kCGImageAlphaPremultipliedLast);
	UIGraphicsPushContext(context);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Setup for Shadow Effect
	color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f * resolution, 2.0f * resolution), 0.0f * resolution, [color CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
	
	// Layer 2
	
	drawRect = CGRectMake(11.0f, 7.125f, 124.0f, 44.875f);
	drawRect.origin.x = roundf(resolution * drawRect.origin.x) / resolution;
	drawRect.origin.y = roundf(resolution * drawRect.origin.y) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	string = @"120000";
	font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0f];
	color = [UIColor colorWithRed:0.384f green:0.533f blue:0.573f alpha:1.0f];
	[color set];
	[string drawInRect:drawRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	
	// Shadow Effect
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
	
	// Inner Shadow Effect
	pixels = (unsigned char *)CGBitmapContextGetData(context);
	width = roundf(bounds.size.width);
	height = roundf(bounds.size.height);
	minX = width;
	maxX = -1.0f;
	minY = height;
	maxY = -1.0f;
	for (NSInteger row = 0; row < height; row++) {
		for (NSInteger column = 0; column < width; column++) {
			if (pixels[4 * (width * row + column) + 3] > 0) {
				minX = MIN(minX, (CGFloat)column);
				maxX = MAX(maxX, (CGFloat)column);
				minY = MIN(minY, (CGFloat)(height - row));
				maxY = MAX(maxY, (CGFloat)(height - row));
			}
		}
	}
	contextImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIGraphicsPopContext();
	context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, imageBounds, contextImage);
	CGContextSetAlpha(context, 0.436f);
	CGContextBeginTransparencyLayer(context, NULL);
	if ((minX <= maxX) && (minY <= maxY)) {
		CGContextSaveGState(context);
		effectBounds = CGRectMake(minX, minY - 1.0f, maxX - minX + 1.0f, maxY - minY + 1.0f);
		effectBounds = CGRectInset(effectBounds, -(ABS(3.0f * cosf(1.571f) * resolution) + 3.0f), -(ABS(3.0f * sinf(1.571f) * resolution) + 3.0f));
		effectBounds = CGRectIntegral(effectBounds);
		color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
		CGContextSetShadowWithColor(context, CGSizeMake(3.0f * cosf(1.571f) * resolution, 3.0f * sinf(1.571f) * resolution - effectBounds.size.height), 3.0f, [color CGColor]);
		bytesPerRow = roundf(effectBounds.size.width);
		maskContext = CGBitmapContextCreate(NULL, roundf(effectBounds.size.width), roundf(effectBounds.size.height), 8, bytesPerRow, NULL, kCGImageAlphaOnly);
		CGContextDrawImage(maskContext, CGRectMake(-effectBounds.origin.x, -effectBounds.origin.y, bounds.size.width, bounds.size.height), contextImage);
		maskImage = CGBitmapContextCreateImage(maskContext);
		data = [NSData dataWithBytes:CGBitmapContextGetData(maskContext) length:bytesPerRow * roundf(effectBounds.size.height)];
		provider = CGDataProviderCreateWithCFData((CFDataRef)data);
		CGImageRelease(contextImage);
		contextImage = CGImageMaskCreate(roundf(effectBounds.size.width), roundf(effectBounds.size.height), 8, 8, bytesPerRow, provider, NULL, 0);
		CGDataProviderRelease(provider);
		CGContextRelease(maskContext);
		CGContextScaleCTM(context, (imageBounds.size.width / bounds.size.width), (imageBounds.size.height / bounds.size.height));
		CGContextClipToMask(context, effectBounds, maskImage);
		CGImageRelease(maskImage);
		effectBounds.origin.y += effectBounds.size.height;
		[[UIColor blackColor] setFill];
		CGContextDrawImage(context, effectBounds, contextImage);
		CGContextRestoreGState(context);
	}
	CGImageRelease(contextImage);
	
	CGContextEndTransparencyLayer(context);
	
	// smallText
	CGContextSetAlpha(context, 1.0f);
	
	// Layer 3
	
	drawRect = CGRectMake(21.0f, 49.0f, 108.0f, 51.0f);
	drawRect.origin.x = roundf(resolution * drawRect.origin.x) / resolution;
	drawRect.origin.y = roundf(resolution * drawRect.origin.y) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	string = @"Followers";
	font = [UIFont fontWithName:@"HelveticaNeue" size:24.0f];
	color = [UIColor colorWithRed:0.294f green:0.412f blue:0.443f alpha:1.0f];
	[color set];
	[string drawInRect:drawRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	
	CGContextRestoreGState(context);
	NSLog(@"Unregistered Copy of Opacity");
	CGColorSpaceRelease(space);
}

@end
