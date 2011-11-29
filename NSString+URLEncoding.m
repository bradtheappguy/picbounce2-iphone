//
//  NSString+URLEncoding.m
//  PicBounce2
//
//  Created by Brad Smith on 11/27/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//


#import "NSString+URLEncoding.h"
@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                             (CFStringRef)self,
                                                             NULL,
                                                             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                             CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end