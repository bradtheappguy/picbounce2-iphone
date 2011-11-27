 //
//  PBAPI.m
//  PicBounce2
//
//  Created by Brad Smith on 31/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBAPI.h"
#import "PBHTTPRequest.h"

NSString *const PBAPIUserWasFollowedNotification = @"PBAPIUserWasFollowedNotification";
NSString *const PBAPIUserWasUnfollowedNotification = @"PBAPIUserWasUnfollowedNotification";

@implementation PBAPI

@synthesize flaggedPhotoID;


+ (PBAPI *)sharedAPI {
  static dispatch_once_t pred;
  static PBAPI *api = nil;
  dispatch_once(&pred, ^{ api = [[self alloc] init]; });
  return api;
}

-(id) init {
  if (self = [super init]) {
    _delegates = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [super dealloc];
}  



#pragma mark Flag Photo
-(void) unflagPhotoWithID:(NSString *)photoID {
  flaggedPhotoID = photoID;
  NSString *urlString = [NSString stringWithFormat:@"http://%@/api/posts/%@/flags",API_BASE,photoID];
  PBHTTPRequest *request = [PBHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
  [request setRequestMethod:@"DELETE"];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(unflagPhotoRequestDidFinish:)];
  [request setDidFailSelector:@selector(unflagPhotoRequestDidFail:)];
  [request startAsynchronous];
}


-(void) unflagPhotoRequestDidFail:(ASIHTTPRequest *)request {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We were unable to unflag this photo at this time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
}


- (void) unflagPhotoRequestDidFinish:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] != 201) {
    [self unflagPhotoRequestDidFail:request];
  }
  else {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.viame.unflagged" object:flaggedPhotoID];
  }
}


-(void) flagPhotoWithID:(NSString *)photoID {
  flaggedPhotoID = photoID;
  NSString *urlString = [NSString stringWithFormat:@"http://%@/api/posts/%@/flags",API_BASE,photoID];
  PBHTTPRequest *request = [PBHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
  [request setRequestMethod:@"POST"];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(flagPhotoRequestDidFinish:)];
  [request setDidFailSelector:@selector(flagPhotoRequestDidFail:)];
  [request startAsynchronous];
}

-(void) flagPhotoRequestDidFail:(ASIHTTPRequest *)request {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We were unable flag this photo at this time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (void) flagPhotoRequestDidFinish:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] != 201) {
    [self flagPhotoRequestDidFail:request];
  }
  else {
    NSLog(@"Flagged");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.viame.flagged" object:flaggedPhotoID];
  }
}


#pragma mark Delete Photo
-(void) deletePhotoWithID:(NSString *)photoID {
  flaggedPhotoID = photoID;
  NSString *urlString = [NSString stringWithFormat:@"http://%@/api/posts/%@",API_BASE,photoID];
  PBHTTPRequest *request = [PBHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
  [request setRequestMethod:@"DELETE"];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(deletePhotoRequestDidFinish:)];
  [request setDidFailSelector:@selector(deletePhotoRequestDidFail:)];
  [request startAsynchronous];
}

-(void) deletePhotoRequestDidFail:(ASIHTTPRequest *)request {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We were unable to delete this photo at this time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (void) deletePhotoRequestDidFinish:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] != 201) {
    [self deletePhotoRequestDidFail:request];
  }
  else {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.viame.deleted" object:flaggedPhotoID];
  }
}


#pragma mark updateFacebbokPages 
-(void) updateFacebookPages:(NSArray *)pages {
  
}
 

#pragma mark Delegate Management
-(void) addDelegate:(id) delegate {
  [_delegates addObject:delegate];
}

-(void) removeDelegate:(id) delegate {
  [_delegates removeObject:delegate];
}

@end
