//
//  Utilities.h
//
//  Created by Avnish Chuchra on 2/1/11.
//  Copyright GraveYard Solutions. All rights reserved.//

#import </usr/include/objc/objc-class.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject
{
}

+ (void)customizeNavigationController:(UINavigationController *)navController;
+ (void)customizeNavigationBar:(UINavigationBar *)navBar;
+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)new;

@end
