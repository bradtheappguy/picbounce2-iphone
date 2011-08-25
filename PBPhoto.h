//
//  PBPhoto.h
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBPhoto : NSObject

@property (readwrite) BOOL uploadFailed;
@property (readwrite) BOOL uploading;
@property (readwrite) BOOL uploadSucceded;
@property (readwrite) CGFloat uploadProgress;

@property (nonatomic, retain) UIImage *image;

-(id) initWithImage:(UIImage *)image;
-(void) retry;

@end
