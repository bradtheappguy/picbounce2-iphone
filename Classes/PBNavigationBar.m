//
//  BSNavigationBar.m
//  PathBoxes
//
//  Created by Brad Smith on 11/24/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "PBNavigationBar.h"


@implementation PBNavigationBar

//-(void) drawRect:(CGRect)rect {  
  //Do Nothing to prevent the standard bar from being drawn
  //}


-(void) addCustomBackground {
  if (!backgroundView){
    UIImage *image  = [UIImage imageNamed:@"bg_navbar"];
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, image.size.height)];
    self.clipsToBounds = NO;
    backgroundView.clipsToBounds = NO;
    backgroundView.contentMode = UIViewContentModeTop;
      backgroundView.image = image;    
 
    [self insertSubview:backgroundView atIndex:0];
    [backgroundView release];
  }
}

-(void) layoutSubviews {
 [self addCustomBackground];
}


@end