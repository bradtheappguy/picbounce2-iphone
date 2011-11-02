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

+ (BOOL) shouldCrosspostToFB {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"CROSSPOST_FB"];
}

+ (void) setShouldCrosspostToFB:(BOOL)should {
  [[NSUserDefaults standardUserDefaults] setBool:should forKey:@"CROSSPOST_FB"];
}

+ (BOOL) shouldCrosspostToTW {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"CROSSPOST_TW"];
}

+ (void) setShouldCrosspostToTW:(BOOL)should {
  [[NSUserDefaults standardUserDefaults] setBool:should forKey:@"CROSSPOST_TW"];
}

@end
