//
//  ImageFilter.m

#include <math.h>
#import "ImageFilter.h"
#import "CatmullRomSpline.h"
#import <Accelerate/Accelerate.h>

#import <math.h>

// utility to find position for x/y values in a matrix
#define DSP_KERNEL_POSITION(x,y,size) (x * size + y)

// forward definitions of our utility methods so the important stuff's at the top
CGContextRef _dsp_utils_CreateARGBBitmapContext (CGImageRef inImage);
void _releaseDspData(void *info,const void *data,size_t size);


/* These constants are used by ImageMagick */
typedef unsigned char Quantum;
typedef double MagickRealType;

#define RoundToQuantum(quantum)  ClampToQuantum(quantum)
#define ScaleCharToQuantum(value)  ((Quantum) (value))
#define SigmaGaussian  ScaleCharToQuantum(4)
#define TauGaussian  ScaleCharToQuantum(20)
#define QuantumRange  ((Quantum) 65535)

/* These are our own constants */
#define SAFECOLOR(color) MIN(255,MAX(0,color))

#define RGB(r, g, b) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation UIImage (ImageFilter)

#pragma mark -
#pragma mark Basic Filters
#pragma mark Internals
- (UIImage*) applyFilter:(FilterCallback)filter context:(void*)context
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	
	int length = CFDataGetLength(m_DataRef);
	
	for (int i=0; i<length; i+=4)
	{
		filter(m_PixelBuf,i,context);
	}  
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
	return finalImage;
}

+ (UIImage*) applyFilter:(FilterCallback)filter context:(void*)context withImage:(UIImage *)image
{
	CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	
	int length = CFDataGetLength(m_DataRef);
	
	for (int i=0; i<length; i+=4)
	{
		filter(m_PixelBuf,i,context);
	}  
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
	return finalImage;
}

#pragma mark C Implementation
void filterGreyscale(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	uint32_t gray = 0.3 * red + 0.59 * green + 0.11 * blue;
	
	pixelBuf[r] = gray;
	pixelBuf[g] = gray;  
	pixelBuf[b] = gray;  
}

void filterSepia(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red * 0.393) + (green * 0.769) + (blue * 0.189));
	pixelBuf[g] = SAFECOLOR((red * 0.349) + (green * 0.686) + (blue * 0.168));
	pixelBuf[b] = SAFECOLOR((red * 0.272) + (green * 0.534) + (blue * 0.131));
}

void filterPosterize(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	int levels = *((int*)context);
	int step = 255 / levels;
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red / step) * step);
	pixelBuf[g] = SAFECOLOR((green / step) * step);
	pixelBuf[b] = SAFECOLOR((blue / step) * step);
}


void filterSaturate(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double t = *((double*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	int avg = ( red + green + blue ) / 3;
	
	pixelBuf[r] = SAFECOLOR((avg + t * (red - avg)));
	pixelBuf[g] = SAFECOLOR((avg + t * (green - avg)));
	pixelBuf[b] = SAFECOLOR((avg + t * (blue - avg)));	
}

void filterBrightness(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double t = *((double*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(red*t);
	pixelBuf[g] = SAFECOLOR(green*t);
	pixelBuf[b] = SAFECOLOR(blue*t);
}

void filterGamma(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	double amount = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(pow(red,amount));
	pixelBuf[g] = SAFECOLOR(pow(green,amount));
	pixelBuf[b] = SAFECOLOR(pow(blue,amount));
}

void filterOpacity(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	
	int a = offset+3;
	
	int alpha = pixelBuf[a];
	
	pixelBuf[a] = SAFECOLOR(alpha * val);
}

double calcContrast(double f, double c){
	return (f-0.5) * c + 0.5;
}

void filterContrast(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(255 * calcContrast((double)((double)red / 255.0f), val));
	pixelBuf[g] = SAFECOLOR(255 * calcContrast((double)((double)green / 255.0f), val));
	pixelBuf[b] = SAFECOLOR(255 * calcContrast((double)((double)blue / 255.0f), val));
}

double calcBias(double f, double bi){
	return (double) (f / ((1.0 / bi - 1.9) * (0.9 - f) + 1));
}

void filterBias(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red * calcBias(((double)red / 255.0f), val)));
	pixelBuf[g] = SAFECOLOR((green * calcBias(((double)green / 255.0f), val)));
	pixelBuf[b] = SAFECOLOR((blue * calcBias(((double)blue / 255.0f), val)));
}

void filterInvert(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(255-red);
	pixelBuf[g] = SAFECOLOR(255-green);
	pixelBuf[b] = SAFECOLOR(255-blue);
}

//
// Noise filter was adapted from ImageMagick
//
static inline Quantum ClampToQuantum(const MagickRealType value)
{
	if (value <= 0.0)
		return((Quantum) 0);
	if (value >= (MagickRealType) QuantumRange)
		return((Quantum) QuantumRange);
	return((Quantum) (value+0.5));
}

static inline double RandBetweenZeroAndOne() 
{
	double value = arc4random() % 1000000;
	value = value / 1000000;
	return value;
}	

static inline Quantum GenerateGaussianNoise(double alpha, const Quantum pixel)
{	
	double beta = RandBetweenZeroAndOne();
	double sigma = sqrt(-2.0*log((double) alpha))*cos((double) (2.0*M_PI*beta));
	double tau = sqrt(-2.0*log((double) alpha))*sin((double) (2.0*M_PI*beta));
	double noise = (MagickRealType) pixel+sqrt((double) pixel)*SigmaGaussian*sigma+TauGaussian*tau;
  
	return RoundToQuantum(noise);
}	

void filterNoise(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	double alpha = 1.0 - *((double*)context);
  
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
  
	pixelBuf[r] = GenerateGaussianNoise(alpha, red);
	pixelBuf[g] = GenerateGaussianNoise(alpha, green);
	pixelBuf[b] = GenerateGaussianNoise(alpha, blue);
}

#pragma mark Filters
-(UIImage*)greyscale 
{
	return [self applyFilter:filterGreyscale context:nil];
}

- (UIImage*)sepia
{
	return [self applyFilter:filterSepia context:nil];
}

+ (UIImage*)sepia:(UIImage *)image
{
	return [UIImage applyFilter:filterSepia context:nil withImage:image];
}

- (UIImage*)posterize:(int)levels
{
	return [self applyFilter:filterPosterize context:&levels];
}

+ (UIImage*)posterize:(int)levels withImage:(UIImage *)image
{
	return [UIImage applyFilter:filterPosterize context:&levels withImage:image];
}

- (UIImage*)saturate:(double)amount
{
	return [self applyFilter:filterSaturate context:&amount];
}

+ (UIImage*)saturate:(double)amount withImage:(UIImage *)image
{
	return [UIImage applyFilter:filterSaturate context:&amount withImage:image];
}

- (UIImage*)brightness:(double)amount
{
	return [self applyFilter:filterBrightness context:&amount];
}

+ (UIImage*)brightness:(double)amount withImage:(UIImage *)image
{
	return [UIImage applyFilter:filterBrightness context:&amount withImage:image];
}

- (UIImage*)gamma:(double)amount
{
	return [self applyFilter:filterGamma context:&amount];	
}

+ (UIImage*)gamma:(double)amount withImage:(UIImage *)image
{
	return [self applyFilter:filterGamma context:&amount withImage:image];	
}

- (UIImage*)opacity:(double)amount
{
	return [self applyFilter:filterOpacity context:&amount];	
}

+ (UIImage*)opacity:(double)amount withImage:(UIImage *)image
{
	return [self applyFilter:filterOpacity context:&amount withImage:image];	
}

- (UIImage*)contrast:(double)amount
{
	return [self applyFilter:filterContrast context:&amount];
}

+ (UIImage*)contrast:(double)amount withImage:(UIImage *)image
{
	return [self applyFilter:filterContrast context:&amount withImage:image];
}

- (UIImage*)bias:(double)amount
{
	return [self applyFilter:filterBias context:&amount];	
}

+ (UIImage*)bias:(double)amount withImage:(UIImage *)image
{
	return [self applyFilter:filterBias context:&amount withImage:image];	
}

- (UIImage*)invert
{
	return [self applyFilter:filterInvert context:nil];
}

+ (UIImage*)invert:(UIImage *)image
{
	return [self applyFilter:filterInvert context:nil withImage:image];
}

- (UIImage*)noise:(double)amount
{
	return [self applyFilter:filterNoise context:&amount];
}

+ (UIImage*)noise:(double)amount withImage:(UIImage *)image
{
	return [self applyFilter:filterNoise context:&amount withImage:image];
}

#pragma mark -
#pragma mark Blends
#pragma mark Internals
- (UIImage*) applyBlendFilter:(FilterBlendCallback)filter other:(UIImage*)other context:(void*)context
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	
	CGImageRef otherImage = other.CGImage;
	CFDataRef m_OtherDataRef = CGDataProviderCopyData(CGImageGetDataProvider(otherImage));  
	UInt8 * m_OtherPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OtherDataRef);  	
	
	int h = self.size.height;
	int w = self.size.width;
	
	
	for (int i=0; i<h; i++)
	{
		for (int j = 0; j < w; j++)
		{
			int index = (i*w*4) + (j*4);
			filter(m_PixelBuf,m_OtherPixelBuf,index,context);			
		}
	}  
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
  CFRelease(m_DataRef);
	CFRelease(m_OtherDataRef);
	return finalImage;
}

+ (UIImage*) applyBlendFilter:(FilterBlendCallback)filter other:(UIImage*)other context:(void*)context withImage:(UIImage *)image
{
	CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	
	CGImageRef otherImage = other.CGImage;
	CFDataRef m_OtherDataRef = CGDataProviderCopyData(CGImageGetDataProvider(otherImage));  
	UInt8 * m_OtherPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OtherDataRef);  	
	
	int h = image.size.height;
	int w = image.size.width;
	
	
	for (int i=0; i<h; i++)
	{
		for (int j = 0; j < w; j++)
		{
			int index = (i*w*4) + (j*4);
			filter(m_PixelBuf,m_OtherPixelBuf,index,context);			
		}
	}  
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
  CFRelease(m_DataRef);
	CFRelease(m_OtherDataRef);
	return finalImage;
}

void applyBlendFilter(FilterBlendCallback filter, CGContextRef bitmapContext, CGContextRef otherContext, void *context)
{
	UInt8 * m_PixelBuf = (UInt8 *) CGBitmapContextGetData(bitmapContext);  
	UInt8 * m_OtherPixelBuf = (UInt8 *) CGBitmapContextGetData(otherContext);  
	
	int h = CGBitmapContextGetWidth(bitmapContext);
	int w = CGBitmapContextGetHeight(bitmapContext);
	
	
	for (int i=0; i<h; i++)
	{
		for (int j = 0; j < w; j++)
		{
			int index = (i*w*4) + (j*4);
			filter(m_PixelBuf,m_OtherPixelBuf,index,context);			
		}
	}  
}

#pragma mark C Implementation
double calcOverlay(float b, float t) {
	return (b > 128.0f) ? 255.0f - 2.0f * (255.0f - t) * (255.0f - b) / 255.0f: (b * t * 2.0f) / 255.0f;
}

void filterOverlay(UInt8 *pixelBuf, UInt8 *pixedBlendBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	int a = offset+3;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	int blendRed = pixedBlendBuf[r];
	int blendGreen = pixedBlendBuf[g];
	int blendBlue = pixedBlendBuf[b];
	double blendAlpha = pixedBlendBuf[a] / 255.0f;
	
	// http://en.wikipedia.org/wiki/Alpha_compositing
	//	double blendAlpha = pixedBlendBuf[a] / 255.0f;
	//	double blendRed = pixedBlendBuf[r] * blendAlpha + red * (1-blendAlpha);
	//	double blendGreen = pixedBlendBuf[g] * blendAlpha + green * (1-blendAlpha);
	//	double blendBlue = pixedBlendBuf[b] * blendAlpha + blue * (1-blendAlpha);
	
	int resultR = SAFECOLOR(calcOverlay(red, blendRed));
	int resultG = SAFECOLOR(calcOverlay(green, blendGreen));
	int resultB = SAFECOLOR(calcOverlay(blue, blendBlue));
	
	// take this result, and blend it back again using the alpha of the top guy	
	pixelBuf[r] = SAFECOLOR(resultR * blendAlpha + red * (1 - blendAlpha));
	pixelBuf[g] = SAFECOLOR(resultG * blendAlpha + green * (1 - blendAlpha));
	pixelBuf[b] = SAFECOLOR(resultB * blendAlpha + blue * (1 - blendAlpha));
	
}

void filterMask(UInt8 *pixelBuf, UInt8 *pixedBlendBuf, UInt32 offset, void *context)
{	
	int r = offset;
  //	int g = offset+1;
  //	int b = offset+2;
	int a = offset+3;
  
	// take this result, and blend it back again using the alpha of the top guy	
	pixelBuf[a] = pixedBlendBuf[r];
}

void filterMerge(UInt8 *pixelBuf, UInt8 *pixedBlendBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	int a = offset+3;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	int blendRed = pixedBlendBuf[r];
	int blendGreen = pixedBlendBuf[g];
	int blendBlue = pixedBlendBuf[b];
	double blendAlpha = pixedBlendBuf[a] / 255.0f;
  
	// take this result, and blend it back again using the alpha of the top guy	
	pixelBuf[r] = SAFECOLOR(blendRed * blendAlpha + red * (1 - blendAlpha));
	pixelBuf[g] = SAFECOLOR(blendGreen * blendAlpha + green * (1 - blendAlpha));
	pixelBuf[b] = SAFECOLOR(blendBlue * blendAlpha + blue * (1 - blendAlpha));	
}

#pragma mark Filters
- (UIImage*) overlay:(UIImage*)other
{
	return [self applyBlendFilter:filterOverlay other:other context:nil];
}

+ (UIImage*) overlay:(UIImage*)other withImage:(UIImage *)image
{
	return [UIImage applyBlendFilter:filterOverlay other:other context:nil withImage:image];
}

- (UIImage*) mask:(UIImage*)other
{
	return [self applyBlendFilter:filterMask other:other context:nil];
}

+ (UIImage*) mask:(UIImage*)other withImage:(UIImage *)image
{
	return [self applyBlendFilter:filterMask other:other context:nil withImage:image];
}

- (UIImage*) merge:(UIImage*)other
{
	return [self applyBlendFilter:filterMerge other:other context:nil];
}

+ (UIImage*) merge:(UIImage*)other withImage:(UIImage *)image
{
	return [self applyBlendFilter:filterMerge other:other context:nil withImage:image];
}


#pragma mark -
#pragma mark Color Correction
#pragma mark C Implementation

typedef struct
{
	int blackPoint;
	int whitePoint;
	int midPoint;
  LevelChannel channel;
} LevelsOptions;


int calcLevelColor(int color, int black, int mid, int white)
{
	if (color < black) {
		return 0;
	} else if (color < mid) {
		int width = (mid - black);
		double stepSize = ((double)width / 128.0f);
		return (int)((double)(color - black) / stepSize);		
	} else if (color < white) {
		int width = (white - mid);
		double stepSize = ((double)width / 128.0f);
		return 128 + (int)((double)(color - mid) / stepSize);		
	}
	
	return 255;
}
void filterLevels(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	LevelsOptions val = *((LevelsOptions*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
  
  int red = pixelBuf[r];
  int green = pixelBuf[g];
  int blue = pixelBuf[b];
  
  switch (val.channel) {
    case LevelChannelComposite:
    {
      pixelBuf[r] = SAFECOLOR(calcLevelColor(red, val.blackPoint, val.midPoint, val.whitePoint));
      pixelBuf[g] = SAFECOLOR(calcLevelColor(green, val.blackPoint, val.midPoint, val.whitePoint));
      pixelBuf[b] = SAFECOLOR(calcLevelColor(blue, val.blackPoint, val.midPoint, val.whitePoint));
    }
      break;
      
    case LevelChannelRed:
    {
      pixelBuf[r] = SAFECOLOR(calcLevelColor(red, val.blackPoint, val.midPoint, val.whitePoint));
    }
      break;
    case LevelChannelGreen:
    {
      pixelBuf[g] = SAFECOLOR(calcLevelColor(green, val.blackPoint, val.midPoint, val.whitePoint));
    }
      break;
      
    case LevelChannelBlue:
    {
      pixelBuf[b] = SAFECOLOR(calcLevelColor(blue, val.blackPoint, val.midPoint, val.whitePoint));
    }
      break;
  }
}

typedef struct
{
	CurveChannel channel;
	CGPoint *points;
	int length;
} CurveEquation;

double valueGivenCurve(CurveEquation equation, double xValue)
{
	assert(xValue <= 255);
	assert(xValue >= 0);
	
	CGPoint point1 = CGPointZero;
	CGPoint point2 = CGPointZero;
	NSInteger idx = 0;
	
	for (idx = 0; idx < equation.length; idx++)
	{
		CGPoint point = equation.points[idx];
		if (xValue < point.x)
		{
			point2 = point;
			if (idx - 1 >= 0)
			{
				point1 = equation.points[idx-1];
			}
			else
			{
				point1 = point2;
			}
			
			break;
		}		
	}
	
	double m = (point2.y - point1.y)/(point2.x - point1.x);
	double b = point2.y - (m * point2.x);
	double y = m * xValue + b;
	return y;
}

void filterCurve(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	CurveEquation equation = *((CurveEquation*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	red = equation.channel & CurveChannelRed ? valueGivenCurve(equation, red) : red;
	green = equation.channel & CurveChannelGreen ? valueGivenCurve(equation, green) : green;
	blue = equation.channel & CurveChannelBlue ? valueGivenCurve(equation, blue) : blue;
	
	pixelBuf[r] = SAFECOLOR(red);
	pixelBuf[g] = SAFECOLOR(green);
	pixelBuf[b] = SAFECOLOR(blue);
}
typedef struct 
{
	double r;
	double g;
	double b;
} RGBAdjust;


void filterAdjust(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	RGBAdjust val = *((RGBAdjust*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(red * (1 + val.r));
	pixelBuf[g] = SAFECOLOR(green * (1 + val.g));
	pixelBuf[b] = SAFECOLOR(blue * (1 + val.b));
}

#pragma mark Filters
/*
 * Levels: Similar to levels in photoshop. 
 * todo: Specify per-channel
 *
 * Parameters:
 *   black: 0-255
 *   mid: 0-255
 *   white: 0-255
 */
- (UIImage*) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white channel:(LevelChannel)channel
{
	LevelsOptions l;
	l.midPoint = mid;
	l.whitePoint = white;
	l.blackPoint = black;
  l.channel = channel;
  
	return [self applyFilter:filterLevels context:&l];
}

/*
 * Levels: Similar to curves in photoshop. 
 * todo: Use a Bicubic spline not a catmull rom spline
 *
 * Parameters:
 *   points: An NSArray of CGPoints through which the curve runs
 *   toChannel: A bitmask of the channels to which the curve gets applied
 */
- (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel
{
	assert([points count] > 1);
	
	CGPoint firstPoint = ((NSValue*)[points objectAtIndex:0]).CGPointValue;
	CatmullRomSpline *spline = [CatmullRomSpline catmullRomSplineAtPoint:firstPoint];	
	NSInteger idx = 0;
	NSInteger length = [points count];
	for (idx = 1; idx < length; idx++)
	{
		CGPoint point = ((NSValue*)[points objectAtIndex:idx]).CGPointValue;
		[spline addPoint:point];
		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
	}		
	
	NSArray *splinePoints = [spline asPointArray];		
	length = [splinePoints count];
	CGPoint *cgPoints = malloc(sizeof(CGPoint) * length);
	memset(cgPoints, 0, sizeof(CGPoint) * length);
	for (idx = 0; idx < length; idx++)
	{
		CGPoint point = ((NSValue*)[splinePoints objectAtIndex:idx]).CGPointValue;
		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
		cgPoints[idx].x = point.x;
		cgPoints[idx].y = point.y;
	}
	
	CurveEquation equation;
	equation.length = length;
	equation.points = cgPoints;	
	equation.channel = channel;
	UIImage *result = [self applyFilter:filterCurve context:&equation];	
	free(cgPoints);
	return result;
}

/*
 * Levels: Similar to curves in photoshop. 
 * todo: Use a Bicubic spline not a catmull rom spline
 *
 * Parameters:
 *   points: An NSArray of CGPoints through which the curve runs
 *   toChannel: A bitmask of the channels to which the curve gets applied
 */
+ (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel withImage:(UIImage *)image
{
	assert([points count] > 1);
	
	CGPoint firstPoint = ((NSValue*)[points objectAtIndex:0]).CGPointValue;
	CatmullRomSpline *spline = [CatmullRomSpline catmullRomSplineAtPoint:firstPoint];	
	NSInteger idx = 0;
	NSInteger length = [points count];
	for (idx = 1; idx < length; idx++)
	{
		CGPoint point = ((NSValue*)[points objectAtIndex:idx]).CGPointValue;
		[spline addPoint:point];
		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
	}		
	
	NSArray *splinePoints = [spline asPointArray];		
	length = [splinePoints count];
	CGPoint *cgPoints = malloc(sizeof(CGPoint) * length);
	memset(cgPoints, 0, sizeof(CGPoint) * length);
	for (idx = 0; idx < length; idx++)
	{
		CGPoint point = ((NSValue*)[splinePoints objectAtIndex:idx]).CGPointValue;
		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
		cgPoints[idx].x = point.x;
		cgPoints[idx].y = point.y;
	}
	
	CurveEquation equation;
	equation.length = length;
	equation.points = cgPoints;	
	equation.channel = channel;
	UIImage *result = [UIImage applyFilter:filterCurve context:&equation withImage:image];	
	free(cgPoints);
	return result;
}


/*
 * adjust: Similar to color balance
 *
 * Parameters:
 *   r: Multiplier of r. Make < 0 to reduce red, > 0 to increase red
 *   g: Multiplier of g. Make < 0 to reduce green, > 0 to increase green
 *   b: Multiplier of b. Make < 0 to reduce blue, > 0 to increase blue
 */
- (UIImage*)adjust:(double)r g:(double)g b:(double)b
{
	RGBAdjust adjust;
	adjust.r = r;
	adjust.g = g;
	adjust.b = b;
	
	return [self applyFilter:filterAdjust context:&adjust];	
}

#pragma mark -
#pragma mark Convolve Operations
#pragma mark Internals

- (UIImage*) applyConvolve:(NSArray*)kernel
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	CFDataRef m_OutDataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	UInt8 * m_OutPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OutDataRef);  
	
	int h = CGImageGetHeight(inImage);
	int w = CGImageGetWidth(inImage);
	
  NSLog(@"applyConvolve width = %d", w);
  NSLog(@"applyConvolve height = %d", h);
  
	int kh = [kernel count] / 2;
	int kw = [[kernel objectAtIndex:0] count] / 2;
	int i = 0, j = 0, n = 0, m = 0;
	
	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++) {
			int outIndex = (i*w*4) + (j*4);
			double r = 0, g = 0, b = 0;
			for (n = -kh; n <= kh; n++) {
				for (m = -kw; m <= kw; m++) {
					if (i + n >= 0 && i + n < h) {
						if (j + m >= 0 && j + m < w) {
							double f = [[[kernel objectAtIndex:(n + kh)] objectAtIndex:(m + kw)] doubleValue];
							if (f == 0) {continue;}
							int inIndex = ((i+n)*w*4) + ((j+m)*4);
							r += m_PixelBuf[inIndex] * f;
							g += m_PixelBuf[inIndex + 1] * f;
							b += m_PixelBuf[inIndex + 2] * f;
						}
					}
				}
			}
			m_OutPixelBuf[outIndex]     = SAFECOLOR((int)r);
			m_OutPixelBuf[outIndex + 1] = SAFECOLOR((int)g);
			m_OutPixelBuf[outIndex + 2] = SAFECOLOR((int)b);
			m_OutPixelBuf[outIndex + 3] = 255;
		}
	}
	
	CGContextRef ctx = CGBitmapContextCreate(m_OutPixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
  CFRelease(m_OutDataRef);
	return finalImage;	
}

- (UIImage*)sepia:(UIImage *)image
{
	return [self applyFilter:filterSepia context:nil];
}

+ (UIImage*) ApplyConvolve:(NSArray*)kernel withImage:(UIImage *)image
{
	CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	CFDataRef m_OutDataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	UInt8 * m_OutPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OutDataRef);  
	
	int h = CGImageGetHeight(inImage);
	int w = CGImageGetWidth(inImage);

  NSLog(@"applyConvolve width = %d", w);
  NSLog(@"applyConvolve height = %d", h);

	int kh = [kernel count] / 2;
	int kw = [[kernel objectAtIndex:0] count] / 2;
	int i = 0, j = 0, n = 0, m = 0;
	
	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++) {
			int outIndex = (i*w*4) + (j*4);
			double r = 0, g = 0, b = 0;
			for (n = -kh; n <= kh; n++) {
				for (m = -kw; m <= kw; m++) {
					if (i + n >= 0 && i + n < h) {
						if (j + m >= 0 && j + m < w) {
							double f = [[[kernel objectAtIndex:(n + kh)] objectAtIndex:(m + kw)] doubleValue];
							if (f == 0) {continue;}
							int inIndex = ((i+n)*w*4) + ((j+m)*4);
							r += m_PixelBuf[inIndex] * f;
							g += m_PixelBuf[inIndex + 1] * f;
							b += m_PixelBuf[inIndex + 2] * f;
						}
					}
				}
			}
			m_OutPixelBuf[outIndex]     = SAFECOLOR((int)r);
			m_OutPixelBuf[outIndex + 1] = SAFECOLOR((int)g);
			m_OutPixelBuf[outIndex + 2] = SAFECOLOR((int)b);
			m_OutPixelBuf[outIndex + 3] = 255;
		}
	}
	
	CGContextRef ctx = CGBitmapContextCreate(m_OutPixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
  CFRelease(m_OutDataRef);
	return finalImage;	
}

void applyConvolveBlur(NSArray* kernel, CGContextRef blurContext, int w, int h)
{
	UInt8 * m_PixelBuf = (UInt8 *) CGBitmapContextGetData(blurContext);  
	UInt8 * m_OutPixelBuf = (UInt8 *) CGBitmapContextGetData(blurContext);  
  
	int kh = [kernel count] / 2;
	int kw = [[kernel objectAtIndex:0] count] / 2;
	int i = 0, j = 0, n = 0, m = 0;
	
	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++) {
			int outIndex = (i*w*4) + (j*4);
			double r = 0, g = 0, b = 0;
			for (n = -kh; n <= kh; n++) {
				for (m = -kw; m <= kw; m++) {
					if (i + n >= 0 && i + n < h) {
						if (j + m >= 0 && j + m < w) {
							double f = [[[kernel objectAtIndex:(n + kh)] objectAtIndex:(m + kw)] doubleValue];
							if (f == 0) {continue;}
							int inIndex = ((i+n)*w*4) + ((j+m)*4);
							r += m_PixelBuf[inIndex] * f;
							g += m_PixelBuf[inIndex + 1] * f;
							b += m_PixelBuf[inIndex + 2] * f;
						}
					}
				}
			}
			m_OutPixelBuf[outIndex]     = SAFECOLOR((int)r);
			m_OutPixelBuf[outIndex + 1] = SAFECOLOR((int)g);
			m_OutPixelBuf[outIndex + 2] = SAFECOLOR((int)b);
			m_OutPixelBuf[outIndex + 3] = 255;
		}
	}
}

#pragma mark Filters
- (UIImage*) sharpen
{
	double dKernel[5][5]={ 
		{0, 0.0, -0.2,  0.0, 0},
		{0, -0.2, 1.8, -0.2, 0},
		{0, 0.0, -0.2,  0.0, 0}};
  
	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	for (int i = 0; i < 5; i++) {
		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
		for (int j = 0; j < 5; j++) {
			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
		}
		[kernel addObject:row];
	}
	return [self applyConvolve:kernel];
}

- (UIImage*) edgeDetect
{
	double dKernel[5][5]={ 
		{0, 0.0, 1.0,  0.0, 0},
		{0, 1.0, -4.0, 1.0, 0},
		{0, 0.0, 1.0,  0.0, 0}};
	
	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	for (int i = 0; i < 5; i++) {
		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
		for (int j = 0; j < 5; j++) {
			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
		}
		[kernel addObject:row];
	}
	return [self applyConvolve:kernel];
}

+ (NSArray*) makeKernel:(int)length
{
	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
	int radius = length / 2;
	
	double m = 1.0f/(2*M_PI*radius*radius);
	double a = 2.0 * radius * radius;
	double sum = 0.0;
	
	for (int y = 0-radius; y < length-radius; y++)
	{
		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    for (int x = 0-radius; x < length-radius; x++)
    {
			double dist = (x*x) + (y*y);
			double val = m*exp(-(dist / a));
			[row addObject:[NSNumber numberWithDouble:val]];			
			sum += val;
    }
		[kernel addObject:row];
	}
	
	//for Kernel-Sum of 1.0
	NSMutableArray *finalKernel = [[[NSMutableArray alloc] initWithCapacity:length] autorelease];
	for (int y = 0; y < length; y++)
	{
		NSMutableArray *row = [kernel objectAtIndex:y];
		NSMutableArray *newRow = [[[NSMutableArray alloc] initWithCapacity:length] autorelease];
    for (int x = 0; x < length; x++)
    {
			NSNumber *value = [row objectAtIndex:x];
			[newRow addObject:[NSNumber numberWithDouble:([value doubleValue] / sum)]];
    }
		[finalKernel addObject:newRow];
	}
	return finalKernel;
}

- (UIImage*) gaussianBlur:(NSUInteger)radius
{
	// Pre-calculated kernel
  //	double dKernel[5][5]={ 
  //		{1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f},
  //		{4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},
  //		{7.0f/273.0f, 26.0f/273.0f, 41.0f/273.0f, 26.0f/273.0f, 7.0f/273.0f},
  //		{4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},             
  //		{1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f}};
  //	
  //	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
  //	for (int i = 0; i < 5; i++) {
  //		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
  //		for (int j = 0; j < 5; j++) {
  //			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
  //		}
  //		[kernel addObject:row];
  //	}
  
  return [self applyConvolve:[UIImage makeKernel:((radius*2)+1)]];
  /*
   double kernel[5][5]={ 
   {1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f},
   {4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},
   {7.0f/273.0f, 26.0f/273.0f, 41.0f/273.0f, 26.0f/273.0f, 7.0f/273.0f},
   {4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},             
   {1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f}};
   return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize5x5];
   */
}

+ (UIImage*) gaussianBlur:(NSUInteger)radius withImage:(UIImage *)image
{
	// Pre-calculated kernel
  //	double dKernel[5][5]={ 
  //		{1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f},
  //		{4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},
  //		{7.0f/273.0f, 26.0f/273.0f, 41.0f/273.0f, 26.0f/273.0f, 7.0f/273.0f},
  //		{4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},             
  //		{1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f}};
  //	
  //	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
  //	for (int i = 0; i < 5; i++) {
  //		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
  //		for (int j = 0; j < 5; j++) {
  //			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
  //		}
  //		[kernel addObject:row];
  //	}
	return [UIImage ApplyConvolve:[UIImage makeKernel:((radius*2)+1)] withImage:image];
}

#pragma mark -
#pragma mark Pre-packaged
- (UIImage*)lomo
{
	UIImage *image = [[self saturate:1.2] contrast:1.15];
	NSArray *redPoints = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                        [NSValue valueWithCGPoint:CGPointMake(137, 118)],
                        [NSValue valueWithCGPoint:CGPointMake(255, 255)],
                        [NSValue valueWithCGPoint:CGPointMake(255, 255)],
                        nil];
	NSArray *greenPoints = [NSArray arrayWithObjects:
                          [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                          [NSValue valueWithCGPoint:CGPointMake(64, 54)],
                          [NSValue valueWithCGPoint:CGPointMake(175, 194)],
                          [NSValue valueWithCGPoint:CGPointMake(255, 255)],
                          nil];
	NSArray *bluePoints = [NSArray arrayWithObjects:
                         [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(59, 64)],
                         [NSValue valueWithCGPoint:CGPointMake(203, 189)],
                         [NSValue valueWithCGPoint:CGPointMake(255, 255)],
                         nil];
	image = [[[image applyCurve:redPoints toChannel:CurveChannelRed] 
            applyCurve:greenPoints toChannel:CurveChannelGreen]
           applyCurve:bluePoints toChannel:CurveChannelBlue];
	
	return [image darkVignette];
}

- (UIImage*) vignette
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	int length = CFDataGetLength(m_DataRef);
	memset(m_PixelBuf,0,length);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	
	int borderWidth = 0.10 * self.size.width;
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, self.size.width, self.size.height));
	CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1);
	CGContextFillEllipseInRect(ctx, CGRectMake(borderWidth, borderWidth, 
                                             self.size.width-(2*borderWidth), 
                                             self.size.height-(2*borderWidth)));
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
  
	UIImage *mask = [finalImage gaussianBlur:10];
	UIImage *blurredSelf = [self gaussianBlur:2];
	UIImage *maskedSelf = [self mask:mask];
	return [blurredSelf merge:maskedSelf];
}

+ (UIImage*) vignette:(UIImage *)image
{
	CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	int length = CFDataGetLength(m_DataRef);
	memset(m_PixelBuf,0,length);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	
	int borderWidth = 0.10 * image.size.width;
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, image.size.width, image.size.height));
	CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1);
	CGContextFillEllipseInRect(ctx, CGRectMake(borderWidth, borderWidth, 
                                             image.size.width-(2*borderWidth), 
                                             image.size.height-(2*borderWidth)));
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
  
	UIImage *mask = [finalImage gaussianBlur:10];
	UIImage *blurredSelf = [UIImage gaussianBlur:2 withImage:image];
	UIImage *maskedSelf = [UIImage mask:mask withImage:image];
	return [blurredSelf merge:maskedSelf];
}

- (UIImage*) darkVignette
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	int length = CFDataGetLength(m_DataRef);
	memset(m_PixelBuf,0,length);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	
	int borderWidth = 0.05 * self.size.width;
	CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, self.size.width, self.size.height));
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(borderWidth, borderWidth, 
                                    self.size.width-(2*borderWidth), 
                                    self.size.height-(2*borderWidth)));
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);	
	
	UIImage *mask = [finalImage gaussianBlur:10];
	
	ctx = CGBitmapContextCreate(m_PixelBuf,  
                              CGImageGetWidth(inImage),  
                              CGImageGetHeight(inImage),  
                              CGImageGetBitsPerComponent(inImage),
                              CGImageGetBytesPerRow(inImage),  
                              CGImageGetColorSpace(inImage),  
                              CGImageGetBitmapInfo(inImage) 
                              ); 
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, self.size.width, self.size.height));
	imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *blackSquare = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);	
	CFRelease(m_DataRef);	
	UIImage *maskedSquare = [blackSquare mask:mask];
	return [self overlay:[maskedSquare opacity:1.0]];
}

+ (UIImage*) darkVignette:(UIImage *)image
{
	CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	int length = CFDataGetLength(m_DataRef);
	memset(m_PixelBuf,0,length);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
                                           CGImageGetWidth(inImage),  
                                           CGImageGetHeight(inImage),  
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),  
                                           CGImageGetColorSpace(inImage),  
                                           CGImageGetBitmapInfo(inImage) 
                                           ); 
	
	
	int borderWidth = 0.05 * image.size.width;
	CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, image.size.width, image.size.height));
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(borderWidth, borderWidth, 
                                    image.size.width-(2*borderWidth), 
                                    image.size.height-(2*borderWidth)));
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);	
	
	UIImage *mask = [finalImage gaussianBlur:10];
	
	ctx = CGBitmapContextCreate(m_PixelBuf,  
                              CGImageGetWidth(inImage),  
                              CGImageGetHeight(inImage),  
                              CGImageGetBitsPerComponent(inImage),
                              CGImageGetBytesPerRow(inImage),  
                              CGImageGetColorSpace(inImage),  
                              CGImageGetBitmapInfo(inImage) 
                              ); 
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, image.size.width, image.size.height));
	imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *blackSquare = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);	
	CFRelease(m_DataRef);	
	UIImage *maskedSquare = [blackSquare mask:mask];
	return [UIImage overlay:[maskedSquare opacity:1.0] withImage:image];
}

// This filter is not done...
- (UIImage*) polaroidish
{
	NSArray *redPoints = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                        [NSValue valueWithCGPoint:CGPointMake(93, 81)],
                        [NSValue valueWithCGPoint:CGPointMake(247, 241)],
                        [NSValue valueWithCGPoint:CGPointMake(255, 255)],
                        nil];
	NSArray *bluePoints = [NSArray arrayWithObjects:
                         [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(57, 59)],
                         [NSValue valueWithCGPoint:CGPointMake(223, 205)],
                         [NSValue valueWithCGPoint:CGPointMake(255, 241)],
                         nil];
	UIImage *image = [[self applyCurve:redPoints toChannel:CurveChannelRed] 
                    applyCurve:bluePoints toChannel:CurveChannelBlue];
  
	redPoints = [NSArray arrayWithObjects:
               [NSValue valueWithCGPoint:CGPointMake(0, 0)],
               [NSValue valueWithCGPoint:CGPointMake(93, 76)],
               [NSValue valueWithCGPoint:CGPointMake(232, 226)],
               [NSValue valueWithCGPoint:CGPointMake(255, 255)],
               nil];
	bluePoints = [NSArray arrayWithObjects:
                [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                [NSValue valueWithCGPoint:CGPointMake(57, 59)],
                [NSValue valueWithCGPoint:CGPointMake(220, 202)],
                [NSValue valueWithCGPoint:CGPointMake(255, 255)],
                nil];
	image = [[image applyCurve:redPoints toChannel:CurveChannelRed] 
           applyCurve:bluePoints toChannel:CurveChannelBlue];
	
	return image;
}

// the real "workhorse" matrix dsp method
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize matrixRows:(int)matrixRows matrixCols:(int)matrixCols clipValues:(bool)shouldClip {
  UIImage* destImg = nil;
  
  CGImageRef inImage = self.CGImage;
  CGContextRef context = _dsp_utils_CreateARGBBitmapContext(inImage);
  if (context == NULL) {
    return destImg; // nil
  }
  
  size_t width = CGBitmapContextGetWidth(context);
  size_t height = CGBitmapContextGetHeight(context);
  size_t bpr = CGBitmapContextGetBytesPerRow(context);
  
  CGRect rect = {{0,0},{width,height}}; 
  CGContextDrawImage(context, rect, inImage); 
  
  // get image data (as char array)
  unsigned char *srcData, *finalData;
  srcData = (unsigned char *)CGBitmapContextGetData (context);
  
  finalData = malloc(bpr * height * sizeof(unsigned char));
  
  if (srcData != NULL && finalData != NULL)
  {
    size_t dataSize = bpr * height;
    
    // copy src to destination: technically this is a bit wasteful as we'll overwrite
    // all but the "alpha" portion of finalData during processing but I'm unaware of 
    // a memcpy with stride function
    memcpy(finalData, srcData, dataSize);
    
    // alloc space for our dsp arrays
    float * srcAsFloat = malloc(width*height*sizeof(float));
    float* resultAsFloat = malloc(width*height*sizeof(float));
    
    // loop through each colour (color) chanel (skip the first chanel, it's alpha and is left alone)
    for (int i=1; i<4; i++) {
      // convert src pixels into float data type
      vDSP_vfltu8(srcData+i,4,srcAsFloat,1,width * height);
      
      // apply matrix using dsp
      switch (matrixSize) {
        case DSPMatrixSize3x3:
          vDSP_f3x3(srcAsFloat, height, width, matrix, resultAsFloat);
          break;
          
        case DSPMatrixSize5x5:
          vDSP_f5x5(srcAsFloat, height, width, matrix, resultAsFloat);
          break;
          
        case DSPMatrixSizeCustom:
          NSAssert(matrixCols > 0 && matrixRows > 0, 
                   @"invalid usage: please use full method definition and pass rows/cols for matrix");
          vDSP_imgfir(srcAsFloat, height, width, matrix, resultAsFloat, matrixRows, matrixCols);
          break;
          
        default:
          break;
      }
      
      // certain operations may result in values to large or too small in our output float array
      // so if necessary we clip the results here. This param is optional so that we don't need to take
      // the speed hit on blur operations or others which can't result in invalid float values.
      if (shouldClip) {
        float min = 0;
        float max = 255;
        vDSP_vclip(resultAsFloat, 1, &min, &max, resultAsFloat, 1, width * height);
      }
      
      // convert back into bytes and copy into finalData
      vDSP_vfixu8(resultAsFloat, 1, finalData+i, 4, width * height);
    }
    
    // clean up dsp space
    free(srcAsFloat);
    free(resultAsFloat);
    
    // create new image from out output data
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, finalData, dataSize, &_releaseDspData);
    CGImageRef cgImage = CGImageCreate(width, height, CGBitmapContextGetBitsPerComponent(context),
                                       CGBitmapContextGetBitsPerPixel(context), CGBitmapContextGetBytesPerRow(context), CGBitmapContextGetColorSpace(context), CGBitmapContextGetBitmapInfo(context), 
                                       dataProvider, NULL, true, kCGRenderingIntentDefault);
    destImg = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    // clear all our cg stuff
    CGDataProviderRelease(dataProvider);
    free(srcData);
  }
  CGContextRelease(context); 
  
  return destImg;
}

// convenience methods to make calling conventions easier with defaults
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize {
  return [self imageByApplyingMatrix:matrix ofSize:matrixSize matrixRows:-1 matrixCols:-1 clipValues:NO];
}
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize clipValues:(bool)shouldClip {
  return [self imageByApplyingMatrix:matrix ofSize:matrixSize matrixRows:-1 matrixCols:-1 clipValues:shouldClip];
}

// uses a pre-calculated kernel
-(UIImage*) imageByApplyingGaussianBlur3x3 {
  static const float kernel[] = { 1/16.0f, 2/16.0f, 1/16.0f, 2/16.0f, 4/16.0f, 2/16.0f, 1/16.0f, 2/16.0f, 1/16.0f };
  
  return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3];
}

// uses a pre-calculated kernel
-(UIImage*) imageByApplyingGaussianBlur5x5 {
  static float kernel[] = 
  { 1/256.0f,  4/256.0f,  6/256.0f,  4/256.0f, 1/256.0f,
    4/256.0f, 16/256.0f, 24/256.0f, 16/256.0f, 4/256.0f,
    6/256.0f, 24/256.0f, 36/256.0f, 24/256.0f, 6/256.0f,
    4/256.0f, 16/256.0f, 24/256.0f, 16/256.0f, 4/256.0f,
    1/256.0f,  4/256.0f,  6/256.0f,  4/256.0f, 1/256.0f };
  
  return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize5x5];
}

// utility for calculating 2d gaussian distribution values for generating arrays
-(float) gausValueAt:(float)x andY:(float)y andSigmaSq:(float)sigmaSq {
  float powerResult =  pow(M_E, -( (x*x+y*y) / (2*sigmaSq) ));
  float result = ( 1/(sqrt(2*M_PI*sigmaSq)) ) * powerResult; 
  return result;
}

// arbitrary sized gaussian blur
-(UIImage*) imageByApplyingOnePassGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq {
  float kernel[kernelSize * kernelSize];
  int halfSize = (int)(0.5 * kernelSize);
  float sum = 0.0;
  
  // generate the gaussian distribution
  for (int i=0; i<kernelSize; i++) {
    for (int j=0; j<kernelSize; j++) {
      float xDistance = 1.0 * i - halfSize;
      float yDistance = 1.0 * j - halfSize;
      float gausValue = [self gausValueAt:xDistance andY:yDistance andSigmaSq:sigmaSq];
      
      kernel[DSP_KERNEL_POSITION(i, j, kernelSize)] = gausValue;
      
      sum += gausValue;
    }
  }
  
  // normalise to avoid distorting brightness
  for (int i=0; i<kernelSize; i++) {
    for (int j=0; j<kernelSize; j++) {
      float gausValue = kernel[DSP_KERNEL_POSITION(i, j, kernelSize)];
      float normal = gausValue / sum;
      
      kernel[DSP_KERNEL_POSITION(i, j, kernelSize)] = normal;
    }
  }
  
  // apply the generated kernel
  return [self imageByApplyingMatrix:kernel ofSize:DSPMatrixSizeCustom matrixRows:kernelSize matrixCols:kernelSize clipValues:NO];
}

// ----------- Fast 2 pass Gaussian blur 
-(float) gaussianValueFor:(float)i withSigmaSq:(float)sigmaSq {
  float powerResult =  pow(M_E, -( (i*i) / (2*sigmaSq) ));
  float result = ( 1/(sqrt(2*M_PI*sigmaSq)) ) * powerResult; 
  return result;
}
-(UIImage*) imageByApplyingGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq {
  float kernel[kernelSize];
  int halfSize = (int)(0.5 * kernelSize);
  
  for (int i=0; i<kernelSize; i++) {
    float distance = 1.0 * i - halfSize;
    float gausValue = [self gaussianValueFor:distance withSigmaSq:sigmaSq];
    
    kernel[i] = gausValue;
  }
  
  [self normaliseMatrix:kernel ofSize:kernelSize];
  
  UIImage* result = self;
  
  // apply this kernel horizontally
  result = [result imageByApplyingMatrix:kernel ofSize:DSPMatrixSizeCustom matrixRows:1 matrixCols:kernelSize clipValues:NO];
  
  // then vertically
  result = [result imageByApplyingMatrix:kernel ofSize:DSPMatrixSizeCustom matrixRows:kernelSize matrixCols:1 clipValues:NO];
  
  return result;
}


-(UIImage*) imageByApplyingBoxBlur3x3 {
  static const float kernel[] = { 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f };
  
  return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3];
}


-(UIImage*) imageByApplyingSharpen3x3 {
  static const float kernel[] = { 0.0f, -1/4.0f, 0.0f, -1/4.0f, 8/4.0f, -1/4.0f, 0.0f, -1/4.0f, 0.0f };
  
  return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3 clipValues:YES];
}

-(UIImage*) imageByApplyingEmboss3x3 {
  static const float kernel[] = { -2.0f, -1.0f, 0.0f, -1.0f, 1.0f, 1.0f, 0.0f, 1.0f, 2.0f };
  
  return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3 clipValues:YES];
}

-(UIImage*) imageByApplyingDiagonalMotionBlur5x5 {
  float kernel[] = { 
    0.22222, 0.27778, 0.22222, 0.05556, 0.00000, 
    0.27778, 0.44444, 0.44444, 0.22222, 0.05556,
    0.22222, 0.44444, 0.55556, 0.44444, 0.22222, 
    0.05556, 0.22222, 0.44444, 0.44444, 0.27778,
    0.00000, 0.05556, 0.22222, 0.27778, 0.22222
  };
  
  [self normaliseMatrix:kernel ofSize:5*5];
  
  return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize5x5 clipValues:YES];
}

-(void) normaliseMatrix:(float*)kernel ofSize:(int)size {
  int entries = size;
  
  // calculate the sum
  float sum = 0.0;
  for (int i=0; i<entries; i++) {
    sum += kernel[i];
  }
  
  // normalise values and store back in array
  for (int i=0; i<entries; i++) {
    float value = kernel[i];
    float normal = value / sum;
    
    kernel[i] = normal;
  }
}


// -------------------------------------------------------------------
// utility methods
// taken from http://iphonedevelopment.blogspot.com/2010/03/irregularly-shaped-uibuttons.html
// and renamed to avoid conflicts for anyone who also includes the original source
CGContextRef _dsp_utils_CreateARGBBitmapContext (CGImageRef inImage)
{
  CGContextRef    context = NULL;
  CGColorSpaceRef colorSpace;
  void *          bitmapData;
  int             bitmapByteCount;
  int             bitmapBytesPerRow;
  
  
  size_t pixelsWide = CGImageGetWidth(inImage);
  size_t pixelsHigh = CGImageGetHeight(inImage);
  bitmapBytesPerRow   = (pixelsWide * 4);
  bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
  
  colorSpace = CGColorSpaceCreateDeviceRGB();
  if (colorSpace == NULL)
    return nil;
  
  bitmapData = malloc( bitmapByteCount );
  if (bitmapData == NULL) 
  {
    CGColorSpaceRelease( colorSpace );
    return nil;
  }
  context = CGBitmapContextCreate (bitmapData,
                                   pixelsWide,
                                   pixelsHigh,
                                   8,
                                   bitmapBytesPerRow,
                                   colorSpace,
                                   kCGImageAlphaPremultipliedFirst);
  if (context == NULL)
  {
    free (bitmapData);
    fprintf (stderr, "Context not created!");
  }
  CGColorSpaceRelease( colorSpace );
  
  return context;
}

// utility method to free any blocks of char data we sent to any data 
// providers
void _releaseDspData(void *info,const void *data,size_t size) {
  free((unsigned char*)data);
}

+ (UIImage *) imageColorComposite:(int)red withGreen:(int)green withBlue:(int)blue withAlpha:(CGFloat)alpha withBlendMode:(CGBlendMode)blendmode withImage:(UIImage *)image
{
  CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 *m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	CGContextRef bitmapContext = CGBitmapContextCreate(m_PixelBuf, CGImageGetWidth(inImage), CGImageGetHeight(inImage), CGImageGetBitsPerComponent(inImage), CGImageGetBytesPerRow(inImage), CGImageGetColorSpace(inImage), CGImageGetBitmapInfo(inImage)); 
  
	CGContextRef fillContext = BitmapContextCreateWithTemplate(bitmapContext);
	BitmapContextColorComposite(fillContext, (unsigned char)red, (unsigned char)green, (unsigned char)blue, alpha, kCGBlendModeNormal);
	BitmapContextComposite(bitmapContext, fillContext, alpha, blendmode);
  BitmapContextRelease(fillContext);
  
  CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
  UIImage *finishedImage = [UIImage imageWithCGImage:imgRef];
  CGImageRelease(imgRef);
  CGContextRelease(bitmapContext);
  return finishedImage;
}

+ (UIImage *) imageCompositeImageNamed:(NSString *)fileName withAlpha:(CGFloat)alpha withBlendMode:(CGBlendMode)blendmode withImage:(UIImage *)image
{
  CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 *m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	CGContextRef bitmapContext = CGBitmapContextCreate(m_PixelBuf, CGImageGetWidth(inImage), CGImageGetHeight(inImage), CGImageGetBitsPerComponent(inImage), CGImageGetBytesPerRow(inImage), CGImageGetColorSpace(inImage), CGImageGetBitmapInfo(inImage)); 
  
  NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
  NSString *docDirectory = [sysPaths objectAtIndex:0];
  NSString *filePath = [NSString stringWithFormat:@"%@/filter_data/%@", docDirectory, fileName];
  UIImage *compositeImage = [[UIImage alloc] initWithContentsOfFile:filePath];
  
  BitmapContextCompositeImage(bitmapContext, compositeImage, alpha, blendmode);
  
  CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
  UIImage *finishedImage = [UIImage imageWithCGImage:imgRef];
  CGImageRelease(imgRef);
  CGContextRelease(bitmapContext);
  return finishedImage;
}

+ (UIImage *) imageCompositeImageTiledNamed:(NSString *)fileName withAlpha:(CGFloat)alpha withBlendMode:(CGBlendMode)blendmode withImage:(UIImage *)image
{
  CGImageRef inImage = image.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 *m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	CGContextRef bitmapContext = CGBitmapContextCreate(m_PixelBuf, CGImageGetWidth(inImage), CGImageGetHeight(inImage), CGImageGetBitsPerComponent(inImage), CGImageGetBytesPerRow(inImage), CGImageGetColorSpace(inImage), CGImageGetBitmapInfo(inImage)); 
  
  NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
  NSString *docDirectory = [sysPaths objectAtIndex:0];
  NSString *filePath = [NSString stringWithFormat:@"%@/filter_data/%@", docDirectory, fileName];
  UIImage *compositeImage = [[UIImage alloc] initWithContentsOfFile:filePath];
  
  BitmapContextCompositeTiledImage(bitmapContext, compositeImage, alpha, blendmode);
  
  CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
  UIImage *finishedImage = [UIImage imageWithCGImage:imgRef];
  CGImageRelease(imgRef);
  CGContextRelease(bitmapContext);
  return finishedImage;
}

CGContextRef BitmapContextCreateClone(CGContextRef bitmapContext)
{
  // NOTE (tsd): use _dsp_utils_CreateARGBBitmapContext here too?
  CGContextRef myContext = CGBitmapContextCreateWithData(CGBitmapContextGetData(bitmapContext), CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext), CGBitmapContextGetBitsPerComponent(bitmapContext), CGBitmapContextGetBytesPerRow(bitmapContext), CGBitmapContextGetColorSpace(bitmapContext), CGBitmapContextGetBitmapInfo(bitmapContext), nil, nil);
  return myContext;
}

CGContextRef BitmapContextCreateWithTemplate(CGContextRef bitmapContext)
{
  CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
  return (CGContextRef)_dsp_utils_CreateARGBBitmapContext(imgRef);
}

void BitmapContextBlur(CGContextRef blurContext, NSUInteger radius)
{
  NSArray *kernel = [UIImage makeKernel:((radius*2)+1)];
  applyConvolveBlur(kernel, blurContext, CGBitmapContextGetWidth(blurContext), CGBitmapContextGetHeight(blurContext));
}

void BitmapContextComposite(CGContextRef bitmapContext, CGContextRef bitmapComposite, CGFloat alpha, CGBlendMode mode)
{
	CGImageRef bitmapImageRef = CGBitmapContextCreateImage(bitmapComposite);  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, bitmapImageRef);
}

void BitmapContextAlphaComposite(CGContextRef bitmapContext, CGContextRef overlayContext, BOOL useAlphaChannel, CGFloat alpha, CGBlendMode mode)
{
  //CGImageCreateWithMask has some alpha - composite using alpha channel
	CGImageRef bitmapImageRef = CGBitmapContextCreateImage(overlayContext);  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, bitmapImageRef);
}

void BitmapContextRelease(CGContextRef bitmapContext)
{
  CGContextRelease(bitmapContext);
}

void BitmapContextCompositeTiledImageNamed(CGContextRef bitmapContext, NSString *fileName, CGFloat alpha, CGBlendMode mode)
{
  UIImage* src = [UIImage imageNamed:fileName];
	CGImageRef bitmapImageRef = [src CGImage];  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawTiledImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, bitmapImageRef);
}

void BitmapContextCompositeTiledImage(CGContextRef bitmapContext, UIImage *image, CGFloat alpha, CGBlendMode mode)
{
	CGImageRef bitmapImageRef = [image CGImage];  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawTiledImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, bitmapImageRef);
}

void BitmapContextCompositeImageNamed(CGContextRef bitmapContext, NSString *fileName, CGFloat alpha, CGBlendMode mode)
{
  UIImage* src = [UIImage imageNamed:fileName];
	CGImageRef bitmapImageRef = [src CGImage];  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, bitmapImageRef);
}

void BitmapContextCompositeImage(CGContextRef bitmapContext, UIImage *image, CGFloat alpha, CGBlendMode mode)
{
	CGImageRef bitmapImageRef = [image CGImage];  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, bitmapImageRef);
}

void BitmapContextColorComposite(CGContextRef bitmapContext, unsigned char red, unsigned char green, unsigned char blue, CGFloat alpha, CGBlendMode mode)
{
	CGContextRef compositeContext = BitmapContextCreateWithTemplate(bitmapContext);
	CGContextSetRGBFillColor(compositeContext, (float)red/255.0, (float)green/255.0, (float)blue/255.0, 1);
	CGContextFillRect(compositeContext, CGRectMake(0, 0, CGBitmapContextGetWidth(compositeContext), CGBitmapContextGetHeight(compositeContext)));
  
  CGImageRef imageRef = CGBitmapContextCreateImage(compositeContext);  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, imageRef);
}

void BitmapContextApplyMask(CGContextRef overlayContext, CGContextRef maskContext)
{
	//CGImageRef overlayImageRef = CGBitmapContextCreateImage(overlayContext);  
	//CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);  
  //CGImageCreateWithMask(overlayImageRef, maskImageRef);
	CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);  
  CGContextClipToMask(overlayContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(overlayContext), CGBitmapContextGetHeight(overlayContext)) }, maskImageRef);
}

void BitmapContextVignetteRGBBlend(CGContextRef bitmapContext, CGFloat red, CGFloat green, CGFloat blue, CGFloat border, CGFloat amount, CGBlendMode mode)
{
	CGContextRef overlayContext = BitmapContextCreateWithTemplate(bitmapContext);
  
	int borderWidth = 0.10 * CGBitmapContextGetWidth(overlayContext);
	CGContextSetRGBFillColor(overlayContext, 0, 0, 0, 1);
	CGContextFillRect(overlayContext, CGRectMake(0, 0, CGBitmapContextGetWidth(overlayContext), CGBitmapContextGetHeight(overlayContext)));
	CGContextSetRGBFillColor(overlayContext, red, green, blue, 1);
	CGContextFillEllipseInRect(overlayContext, CGRectMake(borderWidth, borderWidth, 
                                                        CGBitmapContextGetWidth(overlayContext)-(2*borderWidth), 
                                                        CGBitmapContextGetHeight(overlayContext)-(2*borderWidth)));
  
	CGContextRef maskContext = BitmapContextCreateClone(overlayContext);
	BitmapContextBlur(maskContext, amount);
  
  NSArray *kernel = [UIImage makeKernel:((2*2)+1)];
  applyConvolveBlur(kernel, bitmapContext, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext));
  applyBlendFilter(filterMask, bitmapContext, maskContext, nil);
  
  CGImageRef imageRef = CGBitmapContextCreateImage(bitmapContext);  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, border);
  CGContextDrawImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, imageRef);
}

void BitmapContextSaturateBlend(CGContextRef bitmapContext, CGFloat amount, CGFloat alpha, CGBlendMode mode)
{
  // **** Make a copy into a different buffer, then apply saturate, then use mode to move back in. ******
  // This ok for now because mode is kCGBlendModeNormal and will copy right over
	double t = amount;
	UInt8 * m_PixelBuf = (UInt8 *) CGBitmapContextGetData(bitmapContext);  
  filterSaturate(m_PixelBuf, 0, (void *)&t);
  CGImageRef imageRef = CGBitmapContextCreateImage(bitmapContext);  
  CGContextSetBlendMode(bitmapContext, mode);
  CGContextSetAlpha(bitmapContext, alpha);
  CGContextDrawImage(bitmapContext, (CGRect){ CGPointZero, CGSizeMake(CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)) }, imageRef);
}

+ (void) applyFilter:(FilterCallback)filter context:(void*)context withCGContext:(CGContextRef)bitmapContext
{
	UInt8 * m_PixelBuf = (UInt8 *) CGBitmapContextGetData(bitmapContext);  
	
  size_t pixelsWide = CGBitmapContextGetWidth(bitmapContext);
  size_t pixelsHigh = CGBitmapContextGetHeight(bitmapContext);
  int bitmapBytesPerRow = (pixelsWide * 4);
  int length = (bitmapBytesPerRow * pixelsHigh);
	
	for (int i=0; i<length; i+=4)
	{
		filter(m_PixelBuf, i, context);
	}  
}

+ (void) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel withCGContext:(CGContextRef)bitmapContext
{
	assert([points count] > 1);
	
	CGPoint firstPoint = ((NSValue*)[points objectAtIndex:0]).CGPointValue;
	CatmullRomSpline *spline = [CatmullRomSpline catmullRomSplineAtPoint:firstPoint];	
	NSInteger idx = 0;
	NSInteger length = [points count];
	for (idx = 1; idx < length; idx++)
	{
		CGPoint point = ((NSValue*)[points objectAtIndex:idx]).CGPointValue;
		[spline addPoint:point];
		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
	}		
	
	NSArray *splinePoints = [spline asPointArray];		
	length = [splinePoints count];
	CGPoint *cgPoints = malloc(sizeof(CGPoint) * length);
	memset(cgPoints, 0, sizeof(CGPoint) * length);
	for (idx = 0; idx < length; idx++)
	{
		CGPoint point = ((NSValue*)[splinePoints objectAtIndex:idx]).CGPointValue;
		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
		cgPoints[idx].x = point.x;
		cgPoints[idx].y = point.y;
	}
	
	CurveEquation equation;
	equation.length = length;
	equation.points = cgPoints;	
	equation.channel = channel;
  [UIImage applyFilter:filterCurve context:&equation withCGContext:bitmapContext];
	free(cgPoints);
}

+ (void) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white withCGContext:(CGContextRef)bitmapContext channel:(LevelChannel)channel
{
	LevelsOptions l;
	l.midPoint = mid;
	l.whitePoint = white;
	l.blackPoint = black;
  l.channel = channel;
	
  [UIImage applyFilter:filterLevels context:&l withCGContext:bitmapContext];
}

+ (UIImage *) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white channel:(LevelChannel)channel withImage:(UIImage *)image
{
	LevelsOptions l;
	l.midPoint = mid;
	l.whitePoint = white;
	l.blackPoint = black;
  l.channel = channel;
	
  return [UIImage applyFilter:filterLevels context:&l withImage:image];
}

- (UIImage *) Nostalgia
{
  CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 *m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	CGContextRef bitmapContext = CGBitmapContextCreate(m_PixelBuf, CGImageGetWidth(inImage), CGImageGetHeight(inImage), CGImageGetBitsPerComponent(inImage), CGImageGetBytesPerRow(inImage), CGImageGetColorSpace(inImage), CGImageGetBitmapInfo(inImage)); 
  
	/* Clone the current image, blur it and then composite it back ontop of the original image with 33% soft light blend mode. */
	CGContextRef blurContext = BitmapContextCreateClone(bitmapContext);
	BitmapContextBlur(blurContext, 4/*40*/);
	BitmapContextComposite(bitmapContext, blurContext, 0.33, kCGBlendModeSoftLight);
  BitmapContextRelease(blurContext);
  
	/* Draw a film grain tiling image over the image with 40% overlay blend mode. 
	 * Choose a smaller tile if the target image is a thumbnail, to improve performance.
	 */
	BitmapContextCompositeTiledImageNamed(bitmapContext,
                                        CGBitmapContextGetWidth(bitmapContext) <= 200 &&
                                        CGBitmapContextGetHeight(bitmapContext) <= 200 ?
                                        @"fx-film-filmgrain-thumb.jpg" : @"fx-film-filmgrain.jpg",
                                        0.4, kCGBlendModeOverlay);
  
	/* Draw a stone texture over the image, but masked so that it draws around the edges of the image.
	 * Create an overlay image the same size as the original and draw the tiled image in it.
	 */
	CGContextRef overlayContext = BitmapContextCreateWithTemplate(bitmapContext);
	BitmapContextCompositeTiledImageNamed(overlayContext, @"fx-film-nostalgia-stone.jpg", 1.0, kCGBlendModeNormal);
	/* Create the mask image, the same size as the original, draw the masking image into it. */
	CGContextRef maskContext = BitmapContextCreateWithTemplate(bitmapContext);
	BitmapContextCompositeImageNamed(maskContext, @"fx-film-mask.jpg", 1.0, kCGBlendModeNormal);
  
	/* Apply the mask to the overlay image and then composite the overlay with the original image using 45% overlay blend mode.
	 * This composite respects the alpha channel, whereas other compositing ignores it for performance.
	 */
	BitmapContextApplyMask(overlayContext, maskContext);
	BitmapContextAlphaComposite(bitmapContext, overlayContext, YES, 0.45, kCGBlendModeOverlay);
  
	/* Replace the previous overlay with the special-sauce nostalgia brown tiled image, then repeat the masking
	 * and compositing process above.
	 */
	BitmapContextCompositeTiledImageNamed(overlayContext, @"fx-film-nostalgia-brown.jpg", 1.0, kCGBlendModeNormal);
	BitmapContextApplyMask(overlayContext, maskContext);
	BitmapContextAlphaComposite(bitmapContext, overlayContext, YES, 1.0, kCGBlendModeSoftLight);
	BitmapContextRelease(overlayContext);
	BitmapContextRelease(maskContext);
  
	/* Draw a white vignette "centre spotlight" using 50% overlay blend mode */
	//BitmapContextVignetteRGBBlend(bitmapContext, 0xffffff, 1.05, 0.5, kCGBlendModeOverlay);
	BitmapContextVignetteRGBBlend(bitmapContext, 1.0, 1.0, 1.0, 1.05, 1, kCGBlendModeOverlay);
  
  /* Draw a black vignette using 50% overlay blend mode */
	//BitmapContextVignetteRGBBlend(bitmapContext, 0x000000, 1.5, 0.5, kCGBlendModeOverlay);
	BitmapContextVignetteRGBBlend(bitmapContext, 0.0, 0.0, 0.0, 1.5, 1, kCGBlendModeOverlay);
  
	/* Curves for red, green and blue.
	 * R: 52, 84 / 192, 177 / 255, 222
	 * G: 60, 66 / 207, 180
	 * B: 27, 0 / 225, 255
	 */
  NSArray *redPoints = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                        [NSValue valueWithCGPoint:CGPointMake(52, 84)],
                        [NSValue valueWithCGPoint:CGPointMake(192, 177)],
                        [NSValue valueWithCGPoint:CGPointMake(255, 222)],
                        nil];
  NSArray *greenPoints = [NSArray arrayWithObjects:
                          [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                          [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                          [NSValue valueWithCGPoint:CGPointMake(60, 66)],
                          [NSValue valueWithCGPoint:CGPointMake(207, 180)],
                          nil];
  NSArray *bluePoints = [NSArray arrayWithObjects:
                         [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(27, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(255, 255)],
                         nil];
  [UIImage applyCurve:redPoints toChannel:CurveChannelRed withCGContext:bitmapContext];
  [UIImage applyCurve:greenPoints toChannel:CurveChannelGreen withCGContext:bitmapContext];
  [UIImage applyCurve:bluePoints toChannel:CurveChannelBlue withCGContext:bitmapContext];
  
	/* Fill with #f21bef using a 10% colour blend mode */
	BitmapContextColorComposite(bitmapContext, 0xf2, 0x1b, 0xef, 0.10, kCGBlendModeColor);
  
	/* Levels for red, green and blue, using a 30% normal blend mode */
  /* Levels for red, green and blue, using a 30% normal blend mode
   BitmapContextLevelsChannelsBlend(bitmapContext, 0, 1.0, 255, 0, 255,
   0, 1.0, 235, 0, 255,
   0, 1.0, 242, 0, 255,
   0, 1.0, 253, 0, 200,
   0.3, kCGBlendModeNormal);
   */
  [UIImage levels:0 mid:1.0 white:255 withCGContext:bitmapContext channel:LevelChannelComposite];
  [UIImage levels:0 mid:1.0 white:235 withCGContext:bitmapContext channel:LevelChannelComposite];
  [UIImage levels:0 mid:1.0 white:242 withCGContext:bitmapContext channel:LevelChannelComposite];
  [UIImage levels:0 mid:1.0 white:253 withCGContext:bitmapContext channel:LevelChannelComposite];
	CGContextRef finalContext = BitmapContextCreateWithTemplate(bitmapContext);
	BitmapContextComposite(bitmapContext, finalContext, 0.3, kCGBlendModeNormal);
  
	/* Increase the saturation 30%, applied with 50% normal blend mode */
	BitmapContextSaturateBlend(bitmapContext, 1.3, 0.5, kCGBlendModeNormal);
  
  CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
  //CGImageRef imgRef = CGBitmapContextCreateImage(maskContext);
  UIImage *finishedImage = [UIImage imageWithCGImage:imgRef];
  CGImageRelease(imgRef);
  CGContextRelease(bitmapContext);
  return finishedImage;
}

- (UIImage *) Nashville
{
  CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 *m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	CGContextRef bitmapContext = CGBitmapContextCreate(m_PixelBuf, CGImageGetWidth(inImage), CGImageGetHeight(inImage), CGImageGetBitsPerComponent(inImage), CGImageGetBytesPerRow(inImage), CGImageGetColorSpace(inImage), CGImageGetBitmapInfo(inImage)); 
  
	CGContextRef fillContext = BitmapContextCreateWithTemplate(bitmapContext);
	BitmapContextColorComposite(fillContext, 247, 218, 174, 1.0, kCGBlendModeNormal);
  
	BitmapContextComposite(bitmapContext, fillContext, 1.0, kCGBlendModeMultiply);
  BitmapContextRelease(fillContext);
  
  double amount = 1.3;
  [UIImage applyFilter:filterGamma context:&amount withCGContext:bitmapContext];
  
  [UIImage levels:0 mid:0 white:236 withCGContext:bitmapContext channel:LevelChannelComposite];
  [UIImage levels:37 mid:0 white:255 withCGContext:bitmapContext channel:LevelChannelGreen];
  [UIImage levels:133 mid:0 white:255 withCGContext:bitmapContext channel:LevelChannelBlue];
  
  
  /*
   double amount = 0.6;//6.0;
   [UIImage applyFilter:filterBrightness context:&amount withCGContext:bitmapContext];
   amount = 0.5;//51.0;
   [UIImage applyFilter:filterContrast context:&amount withCGContext:bitmapContext];
   */
  
  CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
  //CGImageRef imgRef = CGBitmapContextCreateImage(fillContext);
  UIImage *finishedImage = [UIImage imageWithCGImage:imgRef];
  CGImageRelease(imgRef);
  CGContextRelease(bitmapContext);
  return finishedImage;
}

@end
