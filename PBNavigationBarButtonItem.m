//
//  PBNavigationBarButtonItem.m
//  PicBounce2
//
//  Created by Brad Smith on 11/13/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBNavigationBarButtonItem.h"




@implementation PBNavigationBarButtonItem

+ (UIBarButtonItem *) itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *image = [UIImage imageNamed:@"btn_navbar_item_n"];
  [button setBackgroundImage:image forState:UIControlStateNormal];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  
  button.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
  button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
  
  [button setTitle:title forState:UIControlStateNormal];
  button.titleLabel.textColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];

  UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];

  return [barItem autorelease]; 
}




@end
