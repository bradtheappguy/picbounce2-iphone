//
//  PBUploadQueue.m
//  PicBounce2
//
//  Created by Brad Smith on 19/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBUploadQueue.h"

@implementation PBUploadQueue

@synthesize count = _count;

+ (id)sharedQueue {
  static dispatch_once_t once;
  static PBUploadQueue *sharedQueue;
  dispatch_once(&once, ^ { sharedQueue = [[self alloc] init]; });
  return sharedQueue;
}

-(id) init {
  if (self = [super init]) {
    images = [[NSMutableArray alloc] init];
    self.count = 0;
  }
  return self;
}

-(void) uploadImage:(UIImage *)image {
  PBPhoto *x = [[PBPhoto alloc] initWithImage:image];
  [images addObject:x];
  self.count = images.count;
}

-(PBPhoto *) photoAtIndex:(NSUInteger)index {
  return [images objectAtIndex:index];
}



@end
