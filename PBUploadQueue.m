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
  PBPost *x = [[PBPost alloc] initWithImage:image];
  [x addObserver:self forKeyPath:@"uploadSucceded" options:NSKeyValueChangeSetting context:nil];
  [images addObject:x];
  self.count = images.count;
  [x release];
}

-(void) uploadText:(NSString *)text {
  PBPost *x = [[PBPost alloc] initWithText:text];
  [x addObserver:self forKeyPath:@"uploadSucceded" options:NSKeyValueChangeSetting context:nil];
  [images addObject:x];
  self.count = images.count;
  [x release];
}

-(PBPost *) photoAtIndex:(NSUInteger)index {
  return [images objectAtIndex:index];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  BOOL test = NO;
  for (PBPost *photo in images) {
    if (photo.uploadSucceded) {
      test = YES;
      [images removeObject:photo];
      self.count = images.count;
    }
  }
  if (test) {
    NSLog(@"Complete@");
  }
}


@end
