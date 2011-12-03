//
//  ImageFilterController.h
//  PicBounce2
//
//  Created by Satyendra on 11/4/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

//#import <QuartzCore/QuartzCore.h>
#import "TVImageFilterController.h"
#import "TVImageFilter.h"
#import "TVImageFilterForFrame.h"

@implementation TVImageFilterController

+ (UIImage *) filteredImageWithImage:(UIImage *)image filter:(int)filterCase{

    NSLog(@"filterCase := %d",filterCase);
    
    TVImageFilterForFrame *filterFrame = [[TVImageFilterForFrame alloc] initImage];
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
           case 13:{
               //-------- Filter for Inkwell ------------
               [filterFrame release];
               return [[image greyscale] adjust:0.255 g:0.255 b:0.255];
               break;
           }
           case 14:{
               //-------- Filter for  Nashville ------------
               [filterFrame release];
               return [[[[[image adjust:0.190  g:0 b:0] bias:0.9999] adjust:0.255 g:0.250 b:0.240] polaroidish] contrast:0.812261];        
               break;
           }
           case 15:{
               //-------- Filter for Hudson ------------
               [filterFrame release];
               return [[[[image bias:0.9969] adjust:0.255 g:0.250 b:0.205] brightness:0.899778] adjust:0.0 g:0.0700 b:0.071];
               break;
           }
           case 16:{
               //-------- Filter for  Earlybird ---------
               [filterFrame release];
               return [[[[image polaroidish] adjust:0.21000 g:0 b:0] adjust:0 g:0.1900 b:0] brightness:0.877778];  
               break;
               
           }

           default:
               return image;
               break;
       }
    return image;
    
	}

@end
