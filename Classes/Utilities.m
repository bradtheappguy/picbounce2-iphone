//
//  Utilities.m
//
//  Created by Avnish Chuchra on 2/1/11.
//  Copyright GraveYard Solutions. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities

+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)new; {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
	
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}


@end
