//
//  FlashButton.h
//  PicBounce2
//
//  Created by Brad Smith on 7/12/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashButton : UIButton {
  UIImageView *flashIcon;
  UIImageView *torchIcon;
  
  UILabel *onLabel;
  UILabel *offLabel;
  UILabel *autoLabel;
  
  UIView *onView;
  UIView *offView;
  UIView *autoView;
  UIView *torchView;
}

@property (readwrite) BOOL expanded;

+ (FlashButton *)button;
- (void) expand;

@end
