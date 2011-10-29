//
//  UIColor+ExtraColorSpecifications.m
//
#import "UIColor+ExtraColorSpecifications.h"

@implementation UIColor(ExtraColorSpecifications)

+ (UIColor *)colorWithRGBInt:(NSUInteger)rgbInt {
    NSUInteger blue = rgbInt & 255;
    NSUInteger green = (rgbInt >> 8) & 255;
    NSUInteger red = (rgbInt >> 16) & 255;
    return [UIColor colorWithRedInt:red greenInt:green blueInt:blue alphaInt:255];
}
+ (UIColor *)colorWithRGBAInt:(NSUInteger)rgbaInt {
    NSUInteger alpha = rgbaInt & 255;
    NSUInteger blue = (rgbaInt >> 8) & 255;
    NSUInteger green = (rgbaInt >> 16) & 255;
    NSUInteger red = (rgbaInt >> 24) & 255;
    return [UIColor colorWithRedInt:red greenInt:green blueInt:blue alphaInt:alpha];    
}
+ (UIColor *)colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue alphaInt:(NSUInteger)alpha {
    if (red > 255) red = 255;
    if (green > 255) green = 255;
    if (blue > 255) blue = 255;
    if (alpha > 255) alpha = 255;
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
}

@end
