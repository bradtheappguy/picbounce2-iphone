//
//  PBAPI.m
//  PicBounce2
//
//  Created by Brad Smith on 31/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBAPI.h"
#import "PBHTTPRequest.h"
@implementation PBAPI

+ (PBAPI *)sharedAPI {
  static dispatch_once_t pred;
  static PBAPI *api = nil;
  dispatch_once(&pred, ^{ api = [[self alloc] init]; });
  return api;
}


-(void) flagPhotoWithID:(NSString *)photoID {
  NSString *urlString = [NSString stringWithFormat:@"http://%@/posts/%@/flags",API_BASE,photoID];
  PBHTTPRequest *request = [[PBHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
  [request setRequestMethod:@"POST"];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(flagPhotoRequestDidFail:)];
  [request setDidFailSelector:@selector(flagPhotoRequestDidFinish:)];
  [request startAsynchronous];
}

-(void) flagPhotoRequestDidFail:(ASIHTTPRequest *)request {
    NSLog(@" ");
}

- (void) flagPhotoRequestDidFinish:(ASIHTTPRequest *)request {
  NSLog(@" ");
}

-(void) deletePhotoWithID:(NSString *)photoID {
  
}

@end
