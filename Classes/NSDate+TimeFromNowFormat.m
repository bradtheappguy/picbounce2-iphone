//
//  NSDate+TimeFromNowFormat.m
//  Clixtr
//
//  Created by Maxime Domain on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDate+TimeFromNowFormat.h"


@implementation NSDate(TimeFromNowFormat) 

- (NSString *) detailPageTime {
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"h:ma - MMMM"];
	NSString *dateString = [dateFormat stringFromDate:self];
	
	[dateFormat setDateFormat:@" d"];
	NSString *day = [dateFormat stringFromDate:self];
	NSString *ordinal = [self ordinal:day];
	NSString *day_with_ordinal = [day stringByAppendingString:ordinal];
	dateString = [dateString stringByAppendingString:day_with_ordinal];
	
	[dateFormat setDateFormat:@" yyyy"];
	NSString *year = [dateFormat stringFromDate:self];
	dateString = [dateString stringByAppendingString:year];
	
	return dateString;
}

- (NSString *) ordinal:(NSString*)day_string {
	int day = [day_string intValue];
	int ones = day % 10;
	int tens = (day/10) % 10;
	if (tens == 1)
		return @"th";
	if (ones == 1)
		return @"st";
	if (ones == 2)
		return @"nd";
	if (ones == 3)
		return @"rd";
	return @"th";
}

- (NSString *) timeFromNowFormatWithLongVersion:(BOOL) longVersion {  
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	double timeFromNow = -1 * [self timeIntervalSinceNow];
	//NSDate *diffDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeFromNow];
	NSString *dateString;
	if (timeFromNow < 3600 ) {
		//[dateFormat setDateFormat: @"M'min ago'"]; 
		//dateString = [dateFormat stringFromDate: diffDate];
		if (longVersion)
			dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / 60)] stringByAppendingString:@" min ago"];
		else
			dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / 60)] stringByAppendingString:@"min ago"];
	}else if (timeFromNow < 24*3600 ) {
		//[dateFormat setDateFormat: @"H'h ago'"]; 
		//dateString = [dateFormat stringFromDate: diffDate];
		if (longVersion)
			if ((int)(timeFromNow / 3600) == 1)
				dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / 3600)] stringByAppendingString:@" hour ago"];
			else
				dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / 3600)] stringByAppendingString:@" hours ago"];
			else
				dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / 3600)] stringByAppendingString:@"h ago"];
	}else if (timeFromNow < (24 *3600* 365)) {
		//[dateFormat setDateFormat: @"D'd ago'"];
		//dateString = [dateFormat stringFromDate: diffDate];
		if (longVersion) {
			if ((int)(timeFromNow / (24*3600)) == 1)
				dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / (24*3600))]stringByAppendingString:@" day ago"];
			else {
				dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / (24*3600))]stringByAppendingString:@" days ago"];
			}
			
		}
		else
			dateString = [[NSString stringWithFormat:@"%d", (int)(timeFromNow / (24*3600))]stringByAppendingString:@"d ago"];
	}else{
		if (longVersion){
			[dateFormat setDateFormat: @"yy-MM-dd"]; 
			dateString = [dateFormat stringFromDate: self];
		}else{
			[dateFormat setDateFormat: @"yy-MM-dd"]; 
			dateString = [dateFormat stringFromDate: self];
		}
	}
	[dateFormat release];
	return dateString;
}
@end
