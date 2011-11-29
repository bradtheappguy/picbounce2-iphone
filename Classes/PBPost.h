//
//  PBPhoto.h
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface PBPost : NSObject

@property (readwrite) BOOL uploadFailed;
@property (readwrite) BOOL uploading;
@property (readwrite) BOOL uploadSucceded;
@property (readwrite) CGFloat uploadProgress;

@property (readwrite) BOOL shouldCrossPostToTwitter;
@property (readwrite) BOOL shouldCrossPostToFacebook;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *text;

-(id) initWithImage:(UIImage *)image;
-(id) initWithText:(NSString *)text;
-(void) retry;
-(void) startUpload;

@end
