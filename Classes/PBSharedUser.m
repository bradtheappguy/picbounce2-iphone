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

+ (NSDate *) facebookExpirationDate {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDateKey"];
}

+ (void) setFacebookExpirationDate:(NSDate *)date {
  [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"FBExpirationDateKey"];
}

+ (void) removeFacebookExpirationDate {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBExpirationDateKey"]) {
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
  }
}

+ (NSString *) facebookAccessToken {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"];
}

+ (void) setFacebookAccessToken:(NSString *)token {
  [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"FBAccessTokenKey"];
}

+ (void) removeFacebookAccessToken {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBAccessTokenKey"]) {
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults synchronize];
  }
}


+ (NSMutableArray *) facebookPages {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"FBSelectedPagesArray"];
}

+ (void) setFacebookPages:(NSMutableArray *)token {
  NSArray *oldFacebbokPages = [self facebookPages];
  
  
  [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"FBSelectedPagesArray"];
}

+ (void) removeFacebookPages {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBSelectedPagesArray"]) {
    [defaults removeObjectForKey:@"FBSelectedPagesArray"];
    [defaults synchronize];
  }
}

+ (void) setShouldCrosspostToFBWall:(BOOL)value {
   [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"ShouldCrosspostToFBWall"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) shouldCrosspostToFBWall {
   return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldCrosspostToFBWall"];
}


+ (NSMutableDictionary *) facebookWall {
  NSAssert(false, @"");
  return [[[NSUserDefaults standardUserDefaults] objectForKey:@"FBSelectedWallArray"] retain];
}

+ (void) setFacebookWall:(NSMutableDictionary *)wall {
   NSAssert(false, @"");
  [[NSUserDefaults standardUserDefaults] setObject:wall forKey:@"FBSelectedWallArray"];
}

+ (void) removeFacebookWall {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBSelectedWallArray"]) {
    [defaults removeObjectForKey:@"FBSelectedWallArray"];
    [defaults synchronize];
  }  
}

@end
