//
//  NSDictionary+NotNull.m
//  PicBounce2
//
//  Created by Brad Smith on 23/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "NSDictionary+NotNull.h"

@implementation NSDictionary (NotNull)
- (id)objectForKeyNotNull:(NSString *)key {
  id object = [self objectForKey:key];
  if ((NSNull *)object == [NSNull null] || (CFNullRef)object == kCFNull)
    return nil;
  
  return object;
}

@end
