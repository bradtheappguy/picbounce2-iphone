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
  
  NSMutableArray *photos;
  NSMutableArray *people;
}

- (NSDictionary *) photoAtIndex:(NSUInteger) index;
- (NSArray *) photos;
- (NSUInteger) numberOfPeople;

@end
