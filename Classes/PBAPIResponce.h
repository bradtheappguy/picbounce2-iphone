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
  
  NSDictionary *user;
  NSMutableArray *photos;
  NSMutableArray *people;
  NSString *url;
  NSString *next;
}

- (BOOL) validate:(id)data;
- (NSDictionary *) photoAtIndex:(NSUInteger) index;
- (NSMutableArray *) photos;
- (NSUInteger) numberOfPeople;
- (NSUInteger) numberOfPhotos;
- (void) mergeNewResponceData:(id)json_string;
- (id) initWithResponceData:(id)json_string;
- (NSURL *) loadMoreDataURL;
- (NSString *) usernameForPersonAtIndex:(NSUInteger) index;
- (NSURL *) followersURL;
- (NSString *) lastLocation;
- (NSString *) timeLabelTextForPhotoAtIndex:(NSUInteger)index;
- (NSUInteger) followingCount;
- (NSUInteger) followersCount;
- (NSURL *) followUserURLForUser;
- (NSString *) followingURL;
- (NSDictionary *) user;
- (NSArray *) people;
@end
