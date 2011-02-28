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
    backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.clipsToBounds = NO;
    backgroundView.contentMode = UIViewContentModeTop;
    backgroundView.image = [UIImage imageNamed:@"header_withlogo.png"];
    
 
    [self insertSubview:backgroundView atIndex:0];
    [backgroundView release];
    
    //self.titleView.alpha = 0.5;
  }
}

-(void) layoutSubviews {
 [self addCustomBackground];
}


@end