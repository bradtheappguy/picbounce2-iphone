//
//  PBAPI.h
//  PicBounce2
//
//  Created by Brad Smith on 31/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBAPI : NSObject
+ (PBAPI *)sharedAPI;
-(void) flagPhotoWithID:(NSString *)photoID;
-(void) deletePhotoWithID:(NSString *)photoID;
@end
