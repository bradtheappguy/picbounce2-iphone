//
//  PicBounce.m
//  PicBounce2
//
//  Created by BradSmith on 4/8/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PicBounce.h"
///#import "PicBounce2AppDelegate.h"

@implementation PicBounce

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    STAssertNotNil([[UIApplication sharedApplication] delegate] , @"");
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

#endif

@end
