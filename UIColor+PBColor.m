//
//  UIColor+PBColor.m
//  PicBounce2
//
//  Created by Brad Smith on 11/16/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "UIColor+PBColor.h"

@implementation UIColor (PBColor)
+ (UIColor *) PBGrayButtonTextColor {
  return [UIColor colorWithRedInt:90 greenInt:92 blueInt:92 alphaInt:255];
} 

+ (UIColor *) PBBlueTextColor {
  return [UIColor colorWithRedInt:77 greenInt:106 blueInt:114 alphaInt:255];
} 

+ (UIColor *) PBRefreshCircleColor {
  return [UIColor colorWithRedInt:119 greenInt:157 blueInt:178 alphaInt:255];
}

+ (UIColor *) PBRefreshCircleBackgroundColor {
    return [UIColor colorWithRedInt:202 greenInt:212 blueInt:213 alphaInt:255];
}
@end
