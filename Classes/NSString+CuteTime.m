//
//  NSString+NSString_CuteTime.m
//  PicBounce2
//
//  Created by Brad Smith on 22/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "NSString+CuteTime.h"

@implementation NSString (CuteTime)

-(NSString *)cuteTimeString {
  NSUInteger timestamp = [self intValue];
  NSUInteger ago = [[NSDate date] timeIntervalSince1970] - timestamp;
  
  NSString *dateString = nil;
  
  if (ago < 60) {  // < 1 hr ago
    dateString = @"Now";
  }
  else if (ago < 3600) {  // < 1 hr ago
    dateString = [[NSString stringWithFormat:@"%d", (int)(ago / 60)] stringByAppendingString:@" m"];
  } else if (ago < 3600 * 24) { // < 24 hr ago
    dateString = [[NSString stringWithFormat:@"%d", (int)(ago / 3600)] stringByAppendingString:@" h"];
  }
  else if (ago < 3600 * 24 * 2) {  // < 2 days
    dateString = [[NSString stringWithFormat:@"%d", (int)(ago / (24*3600))]stringByAppendingString:@" day"];
  }
  else if (ago < 3600 * 24 * 7000) {  // < 7000 days
    dateString = [[NSString stringWithFormat:@"%d", (int)(ago / (24*3600))]stringByAppendingString:@" days"];
  }
  return dateString;
}

@end



@implementation NSNumber (CuteTime)

-(NSString *)cuteTimeString {
    NSUInteger timestamp = [self intValue];
    NSUInteger ago = [[NSDate date] timeIntervalSince1970] - timestamp;
    
    NSString *dateString = nil;
    
    if (ago < 60) {  // < 1 hr ago
		  dateString = @"Now";
	  }
    else if (ago < 3600) {  // < 1 hr ago
      dateString = [[NSString stringWithFormat:@"%d", (int)(ago / 60)] stringByAppendingString:@" m"];
    } else if (ago < 3600 * 24) { // < 24 hr ago
      dateString = [[NSString stringWithFormat:@"%d", (int)(ago / 3600)] stringByAppendingString:@" h"];
    }
    else if (ago < 3600 * 24 * 2) {  // < 2 days
      dateString = [[NSString stringWithFormat:@"%d", (int)(ago / (24*3600))]stringByAppendingString:@" day"];
    }
    else if (ago < 3600 * 24 * 7000) {  // < 7000 days
      dateString = [[NSString stringWithFormat:@"%d", (int)(ago / (24*3600))]stringByAppendingString:@" days"];
    }
    return dateString;
  
}

@end
