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

#pragma mark Flag Photo
-(void) flagPhotoWithID:(NSString *)photoID {
  NSString *urlString = [NSString stringWithFormat:@"http://%@/api/posts/%@/flags",API_BASE,photoID];
  PBHTTPRequest *request = [[PBHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
  [request setRequestMethod:@"POST"];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(flagPhotoRequestDidFinish:)];
  [request setDidFailSelector:@selector(flagPhotoRequestDidFail:)];
  [request startAsynchronous];
}

-(void) flagPhotoRequestDidFail:(ASIHTTPRequest *)request {
  NSLog(@"Failed");
}

- (void) flagPhotoRequestDidFinish:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] != 201) {
    [self flagPhotoRequestDidFail:request];
  }
  else {
    NSLog(@"Flagged");
  }
}


#pragma mark Delete Photo
-(void) deletePhotoWithID:(NSString *)photoID {
  NSString *urlString = [NSString stringWithFormat:@"http://%@/api/posts/%@",API_BASE,photoID];
  PBHTTPRequest *request = [[PBHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
  [request setRequestMethod:@"DELETE"];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(deletePhotoRequestDidFinish:)];
  [request setDidFailSelector:@selector(deletePhotoRequestDidFail:)];
  [request startAsynchronous];
}

-(void) deletePhotoRequestDidFail:(ASIHTTPRequest *)request {
  NSLog(@"Failed");
}

- (void) deletePhotoRequestDidFinish:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] != 201) {
    [self flagPhotoRequestDidFail:request];
  }
  else {
    NSLog(@"Flagged");
  }
}

@end
