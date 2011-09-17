//
//  PBFilteredImage.m
//  test22
//
//  Created by Brad Smith on 15/09/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBFilteredImage.h"
#import <CoreImage/CoreImage.h>

@implementation PBFilteredImage

+ (NSArray *) availableFilters {
  return [NSArray arrayWithObjects:@"one",
          @"xpro",
          @"lomo",
          @"toaster",
          nil];
}

+ (UIImage *) filteredImageWithImage:(UIImage *)image filter:(NSString *)filterName {
  
  int layerCount = 0;
  NSString *filePath = [[NSBundle mainBundle] pathForResource:filterName ofType:@"xml"];
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
  
  NSMutableArray *connections = [[NSMutableArray alloc] init];
  
  CIImage *baseImage = [CIImage imageWithCGImage:image.CGImage];
  [connections addObject:baseImage];
  
  
  NSArray *layers = [dict objectForKey:@"layers"];
  for (NSDictionary *def in layers) {
    layerCount++;
    NSString *type = [def objectForKey:@"type"];
    
    //Layer 0
    if ([type isEqualToString:@"image"] && layerCount > 1) {
      NSString *file = [def objectForKey:@"file"];
      UIImage *image = [UIImage imageNamed:file];
      CIImage *baseImage = [CIImage imageWithCGImage:image.CGImage];
      [connections addObject:baseImage];
      continue;
    }
    
    //Filters
    if ([type isEqualToString:@"filter"]) {
      NSString *classname = [def objectForKey:@"classname"];
      NSDictionary *values = [def objectForKey:@"values"];
      CIFilter *filter = [CIFilter filterWithName:classname];
      
      if ([classname isEqualToString:@"CIColorMatrix"]) {
        [filter setValue:[connections lastObject] forKey:@"inputImage"];
        for (NSString *key in values) {
          NSString *value = [values objectForKey:key];
          CIVector *vector = [CIVector vectorWithString:value];
          key = [key stringByReplacingOccurrencesOfString:@"_CIVectorValue" withString:@""];
          [filter setValue:vector forKey:key];
        }
        [connections addObject:filter.outputImage];
      }
      
      else if ([classname isEqualToString:@"CIHardLightBlendMode"] || 
               [classname isEqualToString:@"CIMultiplyBlendMode"] || 
               [classname isEqualToString:@"CISourceOverCompositing"]) {
        [filter setValue:[connections lastObject] forKey:@"inputBackgroundImage"];
        NSString *imageName = [values objectForKey:@"inputImage"];         
        [filter setValue:[CIImage imageWithCGImage:[UIImage imageNamed:imageName].CGImage] forKey:@"inputImage"];
        [connections addObject:filter.outputImage];
      }
      
      else if ([classname isEqualToString:@"CIWhitePointAdjust"]) {
        [filter setValue:[connections lastObject] forKey:@"inputImage"];
        for (NSString *key in values) {
          NSString *value = [values objectForKey:key];
          CIColor *color = [CIColor colorWithString:value];
          key = [key stringByReplacingOccurrencesOfString:@"_CIColorValue" withString:@""];
          [filter setValue:color forKey:key];
        }
        [connections addObject:filter.outputImage];
      }
      
      else if ([classname isEqualToString:@"CIExposureAdjust"] || 
               [classname isEqualToString:@"CIColorControls"] || 
               [classname isEqualToString:@"CIHueAdjust"] ||
               [classname isEqualToString:@"CIGaussianBlur"]) {
        [filter setValue:[connections lastObject] forKey:@"inputImage"];
        for (NSString *key in values) {
          NSNumber *value = [values objectForKey:key];
          [filter setValue:value forKey:key];
        }
        [connections addObject:filter.outputImage];
      }
      
      else if ([classname isEqualToString:@"CIExposureAdjust"]) {
        [filter setValue:[connections lastObject] forKey:@"inputImage"];
        for (NSString *key in values) {
          id value = [values objectForKey:key];
          if ([key rangeOfString:@"_CIVectorValue"].length > 1) {
            value = [CIVector vectorWithString:value];
            key = [key stringByReplacingOccurrencesOfString:@"_CIVectorValue" withString:@""];
          }
          else if ([key rangeOfString:@"_CIColorValue"].length > 1) {
            value = [CIColor colorWithString:value];
            key = [key stringByReplacingOccurrencesOfString:@"_CIColorValue" withString:@""];
          }
          [filter setValue:value forKey:key];
        }
        [connections addObject:filter.outputImage];
      }
      
      else if ([classname isEqualToString:@"CIRadialGradient"]) {
        NSLog(@"class explicitly not supported from xml: %@",classname);
      }
      else {
        NSLog(@"Unknown classname from xml: %@",classname);
      }
      
    }
  }
  CIContext *context = [CIContext contextWithOptions:nil];
  CGImageRef cgimage = [context createCGImage:[connections lastObject] fromRect:[[connections objectAtIndex:0] extent]];
  [connections release];
  UIImage *i = [UIImage imageWithCGImage:cgimage];
  CFRelease(cgimage);
  return i;
}


@end
