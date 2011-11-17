//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

//#import <QuartzCore/QuartzCore.h>
#import "ImageFilterController.h"
#import "ImageFilter.h"
#import "PBCameraViewController.h"
#import "ImageFilterForFrame.h"

@implementation ImageFilterController

+ (UIImage *) filteredImageWithImage:(UIImage *)image filter:(int)filterCase{

    NSLog(@"filterCase := %d",filterCase);
    
    ImageFilterForFrame *filterFrame = [[ImageFilterForFrame alloc] initImage];
       switch (filterCase) {
			
           case 0:{
                              
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"Snow flakes.png"]];
               [filterFrame release];
               return img;
               break;
           }
           case 1:{
                              
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"boughs.png"]];
               [filterFrame release];
               return [[[img bias:0.9999] adjust:0.0018 g:0.0169 b:0.0606] brightness:1.226044];
               break;
           }
           case 2:{
                             
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"scratched.PNG"]];
               [filterFrame release];
               return [img greyscale];
               break;
           }
           case 3:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"saopaulo.PNG"]];
               [filterFrame release];
               return [[img bias:0.9969] adjust:0.0025 g:0.0169 b:0.3806];
               break;
           }  
           case 4:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"toronto.PNG"]];
               [filterFrame release];
               return [img saturate:0.32000];
               break;
           }
           case 5:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"stockholm.PNG"]];
               [filterFrame release];
               //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
               return img;
               break;
           }
           case 6:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"newYork.PNG"]];
               [filterFrame release];
               return img;
               break;
           }
           case 7:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"july4.png"]];
               [filterFrame release];
               return img;
               break;
           }
           case 8:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"chicago.PNG"]];
               [filterFrame release];
               return [img greyscale];
               break;
           }
             
           default:
               return image;
               break;
       }
    return image;
    
	}

@end
