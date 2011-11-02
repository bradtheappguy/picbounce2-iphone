//
//  ModalDismissDelegate.h
//  PicBounce2
//
//  Created by Thomas DiZoglio on 10/30/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModalDismissDelegate <NSObject>

@optional
- (void)didDismissModalView;

@end
