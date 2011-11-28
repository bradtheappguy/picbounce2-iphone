//
//  ImageFilterForFrame.m
//  PicBounce2
//
//  Created by Satyendra on 11/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "TVImageFilterForFrame.h"

@implementation TVImageFilterForFrame

-(id) initImage
{
	if(self=[super init])
	{
	}
	return self;
}

-(UIImage*)imageWithBorderFromImage:(UIImage*)image:(UIImage*)frameImage
{
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointMake(0,0)];
    [frameImage drawInRect:CGRectMake(0,0,image.size.width  ,image.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end
