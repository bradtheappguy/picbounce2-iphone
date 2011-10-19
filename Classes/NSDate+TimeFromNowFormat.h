//
//  NSDate+TimeFromNowFormat.h
//  Clixtr
//
//  Created by Maxime Domain on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

/*
  Some extra methods for NSDate for the way we display dates in the UI
*/
#import <Foundation/Foundation.h>


@interface NSDate (TimeFromNowFormat) 

-(NSString *) timeFromNowFormatWithLongVersion:(BOOL) longVersion;
-(NSString *) ordinal:(NSString *)day;
-(NSString *) detailPageTime;

@end
