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
@end
