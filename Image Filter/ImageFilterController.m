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
               //return [image sepia];
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"Snow flakes.png"]];
               [filterFrame release];
               //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
               return img;
               break;
           }
           case 1:{
               //return [[image greyscale] adjust:0.0 g:0.0 b:0.360912];
               //return [[image gamma:0.9169] adjust:0.0025 g:0.0169 b:0.0606];
               //   return [[image bias:0.9969] adjust:0.0025 g:0.0169 b:0.3806];
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"boughs.png"]];
               [filterFrame release];
               //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
               //return [[img bias:0.9969] adjust:0.0025 g:0.0169 b:0.3806];
               return img;
               break;
           }
           case 2:{
               //return [image greyscale];
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"scratched.PNG"]];
               [filterFrame release];
               //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
               return [img greyscale];
               break;
           }
           case 3:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"saopaulo.PNG"]];
               [filterFrame release];
               //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
               //return [img adjust:0.0025 g:0.0169 b:0.3806];
               return [[img bias:0.9969] adjust:0.0025 g:0.0169 b:0.3806];
               break;
           }  
           case 4:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"toronto.PNG"]];
               [filterFrame release];
               //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
               return img;
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
               return img;
               break;
           }
             
           default:
               return image;
               break;
       }
    return image;
    
	}

@end
