//
//  NSDate+TimeFromNowFormat.h
//  Clixtr
//
//  Created by Maxime Domain on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(TimeFromNowFormat) 
- (NSString *) timeFromNowFormatWithLongVersion:(BOOL) longVersion;
- (NSString *) ordinal:(NSString *) day;
- (NSString *) detailPageTime;
@end
