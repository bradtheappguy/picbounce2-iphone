//
//  UINavigationBar+BackgroundImage.m
//
//  Created by Avnish Chuchra on 2/1/11.
//  Copyright GraveYard Solutions. All rights reserved.
//

#import "UINavigationBar+BackgroundImage.h"
#import "Utilities.h"


@implementation UINavigationBar (BackgroundImage)

- (void)biInsertSubview:(UIView *)view atIndex:(NSInteger)index {
    [self biInsertSubview:view atIndex:index];
	
    UIView *backgroundImageView = [self viewWithTag:kNavBarImageTag];
    if (backgroundImageView != nil) {
        [self biSendSubviewToBack:backgroundImageView];
    }
}

- (void)biSendSubviewToBack:(UIView *)view {
    [self biSendSubviewToBack:view];
	
    UIView *backgroundImageView = [self viewWithTag:kNavBarImageTag];
    if (backgroundImageView != nil) {
        [self biSendSubviewToBack:backgroundImageView];
    }
}

@end
