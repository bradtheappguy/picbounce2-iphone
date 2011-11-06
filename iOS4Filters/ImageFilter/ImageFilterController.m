//
//  ImageFilterController.m
//  PicBounce2
//
//  Created by Gaurav Goyal on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "ImageFilterController.h"
#import "ImageFilter.h"
#import "PBCameraViewController.h"

@implementation ImageFilterController

+ (UIImage *) filteredImageWithImage:(UIImage *)image filter:(int)filterCase{

       switch (filterCase) {
			
			case 0:
                return [image polaroidish];
            	break;
			case 1:
				return [image sepia];
				break;
            case 2:
               return [image gamma:1.114943];
               break;
   
			default:
				break;
		}
    return image;
    
	}

@end
