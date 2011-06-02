//
//  FacebookSingleton.m
//  PicBounce2
//
//  Created by BradSmith on 4/28/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "FacebookSingleton.h"


@implementation FacebookSingleton

static Facebook *sharedFacebook = nil;

+ (Facebook *) sharedFacebook {
  if (!sharedFacebook) {
   	sharedFacebook = [[Facebook alloc] initWithAppId:@"221310351230872"];
  }
  return sharedFacebook;
}

@end
