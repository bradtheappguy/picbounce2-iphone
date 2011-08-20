//
//  PBUploadQueue.m
//  PicBounce2
//
//  Created by Brad Smith on 19/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBUploadQueue.h"

@implementation PBUploadQueue
+ (id)sharedQueue {
  static dispatch_once_t once;
  static PBUploadQueue *sharedQueue;
  dispatch_once(&once, ^ { sharedQueue = [[self alloc] init]; });
  return sharedQueue;
}

-(id) init {
  if (self = [super init]) {
    images = [[NSMutableArray alloc] init];
  }
  return self;
}

-(void) uploadImage:(UIImage *)image {
  NSObject *x = [[NSObject alloc] init];
  [images addObject:x];
}

-(NSUInteger) count {
  return images.count;
}

-(id) photoAtIndex:(NSUInteger)index {
  return [images objectAtIndex:index];
}

@end
