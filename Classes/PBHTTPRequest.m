//
//  PBHTTPRequest.m
//  PicBounce2
//
//  Created by Brad Smith on 21/09/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBHTTPRequest.h"
#import "AppDelegate.h"

@implementation PBHTTPRequest

+(PBHTTPRequest *) requestWithURL:(NSURL *)URL {
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
  
  NSString *authToken = [(AppDelegate *)[[UIApplication sharedApplication] delegate] authToken];
  [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
  if (authToken) {
    //THE 'X' IN THE PASSWORD IS NEEDED TO FORCE THE NETWORKING LIBRARY TO ADDD
    //THE AUTH TOKEN.  THE SERVER SIDE, (DEVISE) IGNORES IT
    [request setUsername:authToken];
    [request setPassword:@"X"]; 
  }
  [request addRequestHeader:@"Accept" value:@"application/json"];
  
  [request setTimeOutSeconds:60];
  [request setUseCookiePersistence:NO];
  //[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  return (PBHTTPRequest *)request;
}

@end
