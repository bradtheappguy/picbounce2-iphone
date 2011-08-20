//
//  FlashButton.h
//  PicBounce2
//
//  Created by Brad Smith on 7/12/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  FlashButtonModeOff,
  FlashButtonModeAuto,
  FlashButtonModeOn,
  FlashButtonModeTorch
} FlashButtonMode;

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
@property (readwrite) FlashButtonMode mode;
@property (nonatomic, assign) id delegate;

+ (FlashButton *)button;
- (void) expand;

@end
