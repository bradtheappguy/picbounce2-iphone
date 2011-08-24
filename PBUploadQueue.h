//
//  PBUploadQueue.h
//  PicBounce2
//
//  Created by Brad Smith on 19/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBPhoto.h"

@interface PBUploadQueue : NSObject {
  NSMutableArray *images;

}

@property (readwrite) NSUInteger count;

+ (id)sharedQueue;
-(void) uploadImage:(UIImage *)image;
-(NSUInteger) count;
-(id) photoAtIndex:(NSUInteger)index;

@end
