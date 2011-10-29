//
//  main.m
//  PicBounce 2
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {    
  
  /*Method drawRectCustomBackground = class_getInstanceMethod([UINavigationBar class], @selector(drawRectCustomBackground:));
   Method drawRect = class_getInstanceMethod([UINavigationBar class], @selector(drawRect:));
   method_exchangeImplementations(drawRect, drawRectCustomBackground);
   */
    [Utilities swizzleSelector:@selector(insertSubview:atIndex:)
					   ofClass:[UINavigationBar class]
				  withSelector:@selector(biInsertSubview:atIndex:)];
    [Utilities swizzleSelector:@selector(sendSubviewToBack:)
					   ofClass:[UINavigationBar class]
				  withSelector:@selector(biSendSubviewToBack:)];
    
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, nil);
  [pool release];
  return retVal;
}
