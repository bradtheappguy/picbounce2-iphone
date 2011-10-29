//
//  PBUploadQueue.h
//  PicBounce2
//
//  Created by Brad Smith on 19/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBPost.h"

@interface PBUploadQueue : NSObject {
  NSMutableArray *images;

}

@property (readwrite) NSUInteger count;


+ (id)sharedQueue;
-(void) uploadImage:(UIImage *)image;
-(void) uploadText:(NSString *)text;
-(NSUInteger) count;
-(PBPost *) photoAtIndex:(NSUInteger)index;

@end
