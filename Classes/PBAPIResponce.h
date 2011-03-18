//
//  PBAPIResponce.h
//  PicBounce2
//
//  Created by BradSmith on 3/1/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PBAPIResponce : NSObject {
  id data;
  
  NSMutableArray *user;
  NSMutableArray *photos;
  NSMutableArray *people;
  NSString *url;
  NSString *next;
}

- (BOOL) validate:(id)data;
- (NSDictionary *) photoAtIndex:(NSUInteger) index;
- (NSMutableArray *) photos;
- (NSUInteger) numberOfPeople;
- (void) mergeNewResponceData:(id)json_string;

@end
