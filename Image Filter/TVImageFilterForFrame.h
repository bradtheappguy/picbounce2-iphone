//
//  ImageFilterForFrame.h
//  PicBounce2
//
//  Created by Satyendra on 11/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TVImageFilterForFrame : NSObject
-(id) initImage;
- (UIImage*)imageWithBorderFromImage:(UIImage*)image:(UIImage*)frameImage;
@end
