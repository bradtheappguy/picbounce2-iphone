//
//  UINavigationBar+BackgroundImage.h
//
//  Created by Avnish Chuchra on 2/1/11.
//  Copyright GraveYard Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundImage)

- (void)biInsertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)biSendSubviewToBack:(UIView *)view;

@end
