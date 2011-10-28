//
//  PBSharedUser.m
//  PicBounce2
//
//  Created by Brad Smith on 25/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBSharedUser.h"

@implementation PBSharedUser

+ (NSString *) userID {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
}

+ (void) setUserID:(NSString *)userID {
  [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"USER_ID"];
}

@end
