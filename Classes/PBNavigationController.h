//
//  PBNavigationController.h
//  PicBounce2
//
//  Created by Brad Smith on 01/11/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UINavigationBar (BackgroundImage)

- (void)biInsertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)biSendSubviewToBack:(UIView *)view;

@end


@interface PBNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (readwrite, nonatomic) NSUInteger style;

- (id)initWithRootViewController:(UIViewController *)rootViewController style:(NSUInteger)style;

@end
