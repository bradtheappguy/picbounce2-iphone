//
//  PBSharedUser.h
//  PicBounce2
//
//  Created by Brad Smith on 25/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBSharedUser : NSObject

+ (NSString *) userID;
+ (void) setUserID:(NSString *)userID;

+ (BOOL) shouldCrosspostToFB;
+ (void) setShouldCrosspostToFB:(BOOL)should;

+ (BOOL) shouldCrosspostToTW;
+ (void) setShouldCrosspostToTW:(BOOL)should;

+ (NSDate *) facebookExpirationDate;
+ (void) setFacebookExpirationDate:(NSDate *)date;
+ (void) removeFacebookExpirationDate;

+ (NSString *) facebookAccessToken;
+ (void) setFacebookAccessToken:(NSString *)token;
+ (void) removeFacebookAccessToken;

+ (NSMutableArray *) facebookPages;
+ (void) setFacebookPages:(NSMutableArray *)token;
+ (void) removeFacebookPages;

+ (NSMutableDictionary *) facebookWall;
+ (void) setFacebookWall:(NSMutableDictionary *)wall;
+ (void) removeFacebookWall;


+ (void) setShouldCrosspostToFBWall:(BOOL)value;
+ (BOOL) shouldCrosspostToFBWall;

+ (void) setName:(NSString *)userID;
+ (NSString *) name;
    
+ (NSString *) screenname;
+ (void) setScreenname:(NSString *)screenname;
@end
