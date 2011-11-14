//
//  ImageFilter.h

#import <Foundation/Foundation.h>

enum {
  CurveChannelNone                 = 0,
  CurveChannelRed					 = 1 << 0,
  CurveChannelGreen				 = 1 << 1,
  CurveChannelBlue				 = 1 << 2,
};
typedef NSUInteger CurveChannel;

enum {
  LevelChannelComposite    = 0,
  LevelChannelRed					 = 1,
  LevelChannelGreen				 = 2,
  LevelChannelBlue				 = 3,
};
typedef NSUInteger LevelChannel;

typedef void (*FilterCallback)(UInt8 *pixelBuf, UInt32 offset, void *context);
typedef void (*FilterBlendCallback)(UInt8 *pixelBuf, UInt8 *pixelBlendBuf, UInt32 offset, void *context);

// all the different matrix sizes we support
typedef enum {
  DSPMatrixSize3x3,
  DSPMatrixSize5x5,
  DSPMatrixSizeCustom,
} DSPMatrixSize;

@interface UIImage (ImageFilter)

/* Filters */
- (UIImage*) greyscale;
- (UIImage*) sepia;
- (UIImage*) posterize:(int)levels;
- (UIImage*) saturate:(double)amount;
- (UIImage*) brightness:(double)amount;
- (UIImage*) gamma:(double)amount;
- (UIImage*) opacity:(double)amount;
- (UIImage*) contrast:(double)amount;
- (UIImage*) bias:(double)amount;
- (UIImage*) invert;
- (UIImage*) noise:(double)amount;

/* Color Correction */
- (UIImage*) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white channel:(LevelChannel)channel;
- (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel;
- (UIImage*) adjust:(double)r g:(double)g b:(double)b;

/* Convolve Operations */
- (UIImage*) sharpen;
- (UIImage*) edgeDetect;
- (UIImage*) gaussianBlur:(NSUInteger)radius;
- (UIImage*) vignette;
- (UIImage*) darkVignette;
- (UIImage*) polaroidish;

/* Blend Operations */
- (UIImage*) overlay:(UIImage*)other;

/* Bitma Context functions */
void BitmapContextColorComposite(CGContextRef bitmapContext, unsigned char red, unsigned char green, unsigned char blue, CGFloat alpha, CGBlendMode mode);
CGContextRef BitmapContextCreateWithTemplate(CGContextRef bitmapContext);
void BitmapContextRelease(CGContextRef bitmapContext);
void BitmapContextComposite(CGContextRef bitmapContext, CGContextRef bitmapComposite, CGFloat alpha, CGBlendMode mode);
void BitmapContextCompositeImageNamed(CGContextRef bitmapContext, NSString *fileName, CGFloat alpha, CGBlendMode mode);
void BitmapContextCompositeImage(CGContextRef bitmapContext, UIImage *image, CGFloat alpha, CGBlendMode mode);
void BitmapContextCompositeTiledImage(CGContextRef bitmapContext, UIImage *image, CGFloat alpha, CGBlendMode mode);


/* Pre-packed filter sets */
- (UIImage*) lomo;

- (UIImage *) Nostalgia;
- (UIImage *) Nashville;

// New for Via.me filters
+ (UIImage*) ApplyConvolve:(NSArray*)kernel withImage:(UIImage*)image;
+ (UIImage*) applyFilter:(FilterCallback)filter context:(void*)context withImage:(UIImage*)image;
+ (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel withImage:(UIImage*)image;
+ (UIImage*) applyBlendFilter:(FilterBlendCallback)filter other:(UIImage*)other context:(void*)context withImage:(UIImage *)image;

+ (void) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white withCGContext:(CGContextRef)bitmapContext channel:(LevelChannel)channel;
+ (UIImage *) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white channel:(LevelChannel)channel withImage:(UIImage *)image;

+ (UIImage *) imageColorComposite:(int)red withGreen:(int)green withBlue:(int)blue withAlpha:(CGFloat)alpha withBlendMode:(CGBlendMode)blendmode withImage:(UIImage *)image;
+ (UIImage *) imageCompositeImageNamed:(NSString *)fileName withAlpha:(CGFloat)alpha withBlendMode:(CGBlendMode)blendmode withImage:(UIImage *)image;
+ (UIImage *) imageCompositeImageTiledNamed:(NSString *)fileName withAlpha:(CGFloat)alpha withBlendMode:(CGBlendMode)blendmode withImage:(UIImage *)image;

+ (UIImage*)saturate:(double)amount withImage:(UIImage *)image;
+ (UIImage*)posterize:(int)levels withImage:(UIImage *)image;
+ (UIImage*)brightness:(double)amount withImage:(UIImage *)image;
+ (UIImage*)gamma:(double)amount withImage:(UIImage *)image;
+ (UIImage*)opacity:(double)amount withImage:(UIImage *)image;
+ (UIImage*)contrast:(double)amount withImage:(UIImage *)image;
+ (UIImage*)bias:(double)amount withImage:(UIImage *)image;
+ (UIImage*)invert:(UIImage *)image;
+ (UIImage*)noise:(double)amount withImage:(UIImage *)image;

+ (UIImage*) overlay:(UIImage*)other withImage:(UIImage *)image;
+ (UIImage*) mask:(UIImage*)other withImage:(UIImage *)image;
+ (UIImage*) merge:(UIImage*)other withImage:(UIImage *)image;

+ (UIImage*) gaussianBlur:(NSUInteger)radius withImage:(UIImage *)image;

+ (UIImage*)sepia:(UIImage *)image;
+ (UIImage*) darkVignette:(UIImage *)image;
+ (UIImage*) vignette:(UIImage *)image;

// Accelerate framework code
// return auto-released gaussian blurred image
-(UIImage*) imageByApplyingGaussianBlur3x3;
-(UIImage*) imageByApplyingGaussianBlur5x5;

// gaussian blur with arbitrary kernel size and sigma (controlling the std deviation => spread => blur amount)
// higher sigmaSq values result in more blur... experiment to find something appropriate for your application,
// for kernel size of 8 you might try 30 to start
-(UIImage*) imageByApplyingGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq;

// methods are provided for both a two pass (default) and one pass gaussian blur but the two pass is STRONGLY
// recomended due to mathematical equivallence and greatly increased speed for large kernels
// as such I've left this commented out by default
// -(UIImage*) imageByApplyingOnePassGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq;

// sharpening
-(UIImage*) imageByApplyingSharpen3x3;

// others
-(UIImage*) imageByApplyingBoxBlur3x3; // not generally as good as gaussian

-(UIImage*) imageByApplyingEmboss3x3;

-(UIImage*) imageByApplyingDiagonalMotionBlur5x5;
-(UIImage*) imageByApplyingDiagonalMotionBlur7x7;

// utility for normalizing matrices
-(void) normaliseMatrix:(float*)kernel ofSize:(int)size;


// if you call these methods directly and do something interesting with them please consider
// sending me details on github so that I may incorporate your awesomeness into the library
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize;
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize;
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize clipValues:(bool)shouldClip;

CGContextRef _dsp_utils_CreateARGBBitmapContext (CGImageRef inImage);

@end
