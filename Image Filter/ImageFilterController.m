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
               return [[[img bias:0.8699] adjust:0.1018 g:0.0169 b:0.0406] brightness:1.001644];
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
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"stockholm.png"]];
               [filterFrame release];
               //return [[img bias:0.9969] adjust:0.0000 g:0.0000 b:2.0806];
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
           case 9:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"Grainy-film.png"]];
               [filterFrame release];
               return img;
               break;
           }
           case 10:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"bordeaux.png"]];
               [filterFrame release];
               return img;
               break;
           }
           case 11:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"Scratched-Soft-Sepia.png"]];
               [filterFrame release];
               return img;
               break;
           }
           case 12:{
               
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"Old--BW-Film.png"]];
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
