//
//  PBNavigationBarButtonItem.h
//  PicBounce2
//
//  Created by Brad Smith on 11/13/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBNavigationBarButtonItem : UIBarButtonItem
+ (UIBarButtonItem *) itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
