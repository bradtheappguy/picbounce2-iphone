//
//  PBAPI.h
//  PicBounce2
//
//  Created by Brad Smith on 31/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PBAPIUserWasFollowedNotification;
extern NSString *const PBAPIUserWasUnfollowedNotification;


@interface PBAPI : NSObject {
  NSMutableArray *_delegates;
}

+ (PBAPI *)sharedAPI;
-(void) flagPhotoWithID:(NSString *)photoID;
-(void) deletePhotoWithID:(NSString *)photoID;


-(void) addDelegate:(id) delegate;
-(void) removeDelegate:(id) delegate;

@end
