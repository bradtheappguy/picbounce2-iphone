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
               //-------- Filter for Lamo-fi ------------              
               UIImage *img = [filterFrame imageWithBorderFromImage: image :[UIImage imageNamed:@"borderRoughInstagram.png"]];
               [filterFrame release];
               return [[[[img bias:0.9999] adjust:0.255 g:0.250 b:0.295] adjust:0.175 g:0.150 b:0.105] brightness:0.887648];
               break;
           }
           case 14:{
               //-------- Filter for Inkwell ------------
               UIImage *img = [filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"filterBorderPlainWhite.png"]];
               [filterFrame release];
               //return [[[image greyscale] adjust:0.255 g:0.255 b:0.255] brightness:1.010540];
               return [[[img greyscale] brightness:1.033940] adjust:0.255 g:0.255 b:0.255];
               break;
           }
           case 15:{
               //-------- Filter for Valencia ----------- 
               [filterFrame release];
               return [[[image adjust:0.0 g:0.049970 b:0] brightness:1.089999] saturate:0.781100];
               break;
           }
           case 16:{
               //-------- Filter for  X-pro || --------------
               UIImage *img = [filterFrame imageWithBorderFromImage: image :[UIImage imageNamed:@"filterBorderBlackBevel.png"]];
               UIImage *img1 = [filterFrame imageWithBorderFromImage:img :[UIImage imageNamed:@"redYellowGradient.png"]];
               [filterFrame release];
               return img1;
               break;
           }
           case 17:{
               //-------- Filter for  Rise ----------
               UIImage *img = [[filterFrame imageWithBorderFromImage:image :[UIImage imageNamed:@"redYellowGradient.png"]] brightness:0.999999];
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
