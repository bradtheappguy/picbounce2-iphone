//
//	image@2x.m
//	New Image
//
//	Created by Ruth Martin on 8/26/11
//	Copyright Like Thought, LLC. All rights reserved.
//	THIS CODE IS FOR EVALUATION ONLY. YOU MAY NOT USE IT FOR ANY OTHER PURPOSE UNLESS YOU PURCHASE A LICENSE FOR OPACITY.
//

#import "image@2x.h"

const CGFloat krefreshEllipseWidth = 100.0f;
const CGFloat krefreshEllipseHeight = 100.0f;

@implementation refreshEllipse


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
	return CGSizeMake(krefreshEllipseWidth, krefreshEllipseHeight);
}

- (void)drawRect:(CGRect)dirtyRect
{
	CGRect imageBounds = CGRectMake(0.0f, 0.0f, krefreshEllipseWidth, krefreshEllipseHeight);
	CGRect bounds = [self bounds];
	CGContextRef context = UIGraphicsGetCurrentContext();
	size_t bytesPerRow;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat alignStroke;
	CGFloat resolution;
	CGMutablePathRef path;
	CGRect drawRect;
	UIColor *color;
	CGImageRef contextImage;
	CGRect effectBounds;
	unsigned char *pixels;
	CGFloat minX, maxX, minY, maxY;
	NSUInteger width, height;
	CGContextRef maskContext;
	CGImageRef maskImage;
	CGDataProviderRef provider;
	NSData *data;
	CGGradientRef gradient;
	NSMutableArray *colors;
	CGPoint point;
	CGPoint point2;
	CGAffineTransform transform;
	CGMutablePathRef tempPath;
	CGRect pathBounds;
	CGFloat stroke;
	CGFloat locations[2];
	resolution = 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// shadowOuter
	
	// Setup for Inner Shadow Effect
	bytesPerRow = 4 * roundf(bounds.size.width);
	context = CGBitmapContextCreate(NULL, roundf(bounds.size.width), roundf(bounds.size.height), 8, bytesPerRow, space, kCGImageAlphaPremultipliedLast);
	UIGraphicsPushContext(context);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Layer 3
	
	alignStroke = 0.0f;
	path = CGPathCreateMutable();
	drawRect = CGRectMake(4.0f, 4.0f, 92.0f, 92.0f);
	drawRect.origin.x = (roundf(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
	drawRect.origin.y = (roundf(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	CGPathAddEllipseInRect(path, NULL, drawRect);
	color = [UIColor colorWithRed:0.89f green:0.859f blue:0.835f alpha:0.46f];
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
	CGContextSetAlpha(context, 0.335f);
	CGContextBeginTransparencyLayer(context, NULL);
	if ((minX <= maxX) && (minY <= maxY)) {
		CGContextSaveGState(context);
		effectBounds = CGRectMake(minX, minY - 1.0f, maxX - minX + 1.0f, maxY - minY + 1.0f);
		effectBounds = CGRectInset(effectBounds, -(ABS(0.0f * cosf(1.571f) * resolution) + 13.0f), -(ABS(0.0f * sinf(1.571f) * resolution) + 13.0f));
		effectBounds = CGRectIntegral(effectBounds);
		color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
		CGContextSetShadowWithColor(context, CGSizeMake(0.0f * cosf(1.571f) * resolution, 0.0f * sinf(1.571f) * resolution - effectBounds.size.height), 13.0f, [color CGColor]);
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
	
	// outerCircle
	CGContextSetAlpha(context, 1.0f);
	
	// Setup for Shadow Effect
	color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f * resolution, 0.0f * resolution), 2.708f * resolution, [color CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
	
	// Layer 1
	
	alignStroke = 0.0f;
	path = CGPathCreateMutable();
	drawRect = CGRectMake(10.0f, 10.0f, 80.0f, 80.0f);
	drawRect.origin.x = (roundf(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
	drawRect.origin.y = (roundf(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	CGPathAddEllipseInRect(path, NULL, drawRect);
	colors = [NSMutableArray arrayWithCapacity:2];
	color = [UIColor colorWithRed:0.878f green:0.835f blue:0.8f alpha:1.0f];
	[colors addObject:(id)[color CGColor]];
	locations[0] = 0.0f;
	color = [UIColor colorWithRed:0.969f green:0.949f blue:0.933f alpha:1.0f];
	[colors addObject:(id)[color CGColor]];
	locations[1] = 1.0f;
	gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	transform = CGAffineTransformMakeRotation(1.571f);
	tempPath = CGPathCreateMutable();
	CGPathAddPath(tempPath, &transform, path);
	pathBounds = CGPathGetPathBoundingBox(tempPath);
	point = pathBounds.origin;
	point2 = CGPointMake(CGRectGetMaxX(pathBounds), CGRectGetMinY(pathBounds));
	transform = CGAffineTransformInvert(transform);
	point = CGPointApplyAffineTransform(point, transform);
	point2 = CGPointApplyAffineTransform(point2, transform);
	CGPathRelease(tempPath);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	CGPathRelease(path);
	
	// Shadow Effect
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
	
	// iner
	
	// Setup for Inner Shadow Effect
	bytesPerRow = 4 * roundf(bounds.size.width);
	context = CGBitmapContextCreate(NULL, roundf(bounds.size.width), roundf(bounds.size.height), 8, bytesPerRow, space, kCGImageAlphaPremultipliedLast);
	UIGraphicsPushContext(context);
	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
	
	// Layer 2
	
	stroke = 0.0f;
	stroke *= resolution;
	if (stroke < 1.0f) {
		stroke = ceilf(stroke);
	} else {
		stroke = roundf(stroke);
	}
	stroke /= resolution;
	alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
	path = CGPathCreateMutable();
	drawRect = CGRectMake(14.0f, 14.0f, 72.0f, 72.0f);
	drawRect.origin.x = (roundf(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
	drawRect.origin.y = (roundf(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
	CGPathAddEllipseInRect(path, NULL, drawRect);
	color = [UIColor colorWithRed:0.404f green:0.349f blue:0.302f alpha:1.0f];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	color = [UIColor colorWithRed:0.89f green:0.859f blue:0.835f alpha:1.0f];
	[color setStroke];
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
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
	CGContextSetAlpha(context, 0.75f);
	CGContextBeginTransparencyLayer(context, NULL);
	if ((minX <= maxX) && (minY <= maxY)) {
		CGContextSaveGState(context);
		effectBounds = CGRectMake(minX, minY - 1.0f, maxX - minX + 1.0f, maxY - minY + 1.0f);
		effectBounds = CGRectInset(effectBounds, -(ABS(0.0f * cosf(1.571f) * resolution) + 4.375f), -(ABS(0.0f * sinf(1.571f) * resolution) + 4.375f));
		effectBounds = CGRectIntegral(effectBounds);
		color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
		CGContextSetShadowWithColor(context, CGSizeMake(0.0f * cosf(1.571f) * resolution, 0.0f * sinf(1.571f) * resolution - effectBounds.size.height), 4.375f, [color CGColor]);
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
	
	CGContextRestoreGState(context);
	NSLog(@"Unregistered Copy of Opacity");
	CGColorSpaceRelease(space);
}

@end
