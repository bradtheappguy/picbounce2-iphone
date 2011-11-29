//
//  PBUploadQueue.m
//  PicBounce2
//
//  Created by Brad Smith on 19/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBUploadQueue.h"
#import "PBPost.h"

@implementation PBUploadQueue

@synthesize count = _count;

+ (id)sharedQueue {
  static dispatch_once_t once;
  static PBUploadQueue *sharedQueue;
  dispatch_once(&once, ^ { 
    sharedQueue = [[self alloc] init]; 
    [sharedQueue setMaxConcurrentOperationCount:1];
    sharedQueue.delegate = sharedQueue;
    sharedQueue.requestDidStartSelector = @selector(requestDidStart:);
    sharedQueue.requestDidFinishSelector = @selector(requestDidFinish:);
    sharedQueue.requestDidFailSelector = @selector(requestDidFail:);
  });
  

  
  return sharedQueue;
}

-(id) init {
  if (self = [super init]) {
    images = [[NSMutableArray alloc] init];
    self.count = 0;
  }
  return self;
}

-(void) uploadText:(NSString *)text withImage:(UIImage *)image
crossPostingToTwitter:(BOOL)shouldCrossPostToTwitter
crossPostingToFacebook:(BOOL)shouldCrossPostToFacebook {
  
  PBPost *x = [[PBPost alloc] initWithImage:image];
  x.text = text;
  x.shouldCrossPostToTwitter = shouldCrossPostToTwitter;
  x.shouldCrossPostToFacebook = shouldCrossPostToFacebook;

  [images addObject:x];
  self.count = images.count;
  [x startUpload];
  [x release];
}

-(void) uploadText:(NSString *)text 
crossPostingToTwitter:(BOOL)shouldCrossPostToTwitter
crossPostingToFacebook:(BOOL)shouldCrossPostToFacebook {
  
  PBPost *x = [[PBPost alloc] initWithText:text];
  x.shouldCrossPostToTwitter = shouldCrossPostToTwitter;
  x.shouldCrossPostToFacebook = shouldCrossPostToFacebook;

  [images addObject:x];
  [x startUpload];
  self.count = images.count;
  [x release];
}

-(PBPost *) photoAtIndex:(NSUInteger)index {
  if (index < images.count) {
    return [images objectAtIndex:index];
  }
  return nil;
  
}

-(void) removePost:(PBPost *)post {
  [images removeObject:post];
  self.count = images.count;
}

-(void) removeCompletedPosts {
  NSMutableArray *postsToRemove = [[NSMutableArray alloc] init];
  for (PBPost *post in images) {
    if (post.uploadSucceded) {
      [postsToRemove addObject:post];
    }
  }
  
  [images removeObjectsInArray:postsToRemove];
  [postsToRemove release];
  _count = images.count;
}



-(void) requestDidStart:(ASIHTTPRequest *)request {
  
}

-(void) requestDidFinish:(ASIHTTPRequest *)request {
  //PBPost *x = request.delegate;
  //[images removeObject:x];
}

-(void) requestDidFail:(ASIHTTPRequest *)request {
  
}





@end
