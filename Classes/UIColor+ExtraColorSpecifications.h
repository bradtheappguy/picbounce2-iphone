//
//  UIColor+ExtraColorSpecifications.h
//
//  Provides additional convenience methods for UIColor creation.

@interface UIColor(ExtraColorSpecifications)
+ (UIColor *)colorWithRGBInt:(NSUInteger)rgbInt; // Assumes alpha is 0xFF
+ (UIColor *)colorWithRGBAInt:(NSUInteger)rgbaInt;
+ (UIColor *)colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue alphaInt:(NSUInteger)alpha;
@end
