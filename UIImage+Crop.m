//
//  UIImage+Crop.m
//  PicBounce2
//
//  Created by Brad Smith on 11/27/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//
//  Based on public domain source code found here: http://stackoverflow.com/q/7704399/42323 

#import "UIImage+Crop.h"

@implementation UIImage (Crop)


- (UIImage *)imageCroppedToRect:(CGRect)rect {
  CGFloat scale = [[UIScreen mainScreen] scale];
  rect = CGRectMake(rect.origin.x*scale , rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);        
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef]; 
  CGImageRelease(imageRef);
  return result;
}

@end
