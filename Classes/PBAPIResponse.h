//
//  PBAPIresponse.h
//  PicBounce2
//
//  Created by BradSmith on 3/1/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PBAPIresponse : NSObject {
  id data;
  
  NSDictionary *user;
  NSMutableArray *posts;
  NSMutableArray *people;
  NSString *url;

}

@property (nonatomic, retain)   NSString *next;

- (BOOL) validate:(id)data;
-(NSDictionary *) personAtIndex:(NSUInteger) index;
- (NSDictionary *) photoAtIndex:(NSUInteger) index;
- (NSMutableArray *) posts;
- (NSUInteger) numberOfPeople;
- (NSUInteger) numberOfPosts;
- (void) mergeNewresponseData:(id)json_string;
- (id) initWithresponseData:(id)json_string;
- (NSURL *) loadMoreDataURL;
- (NSString *) usernameForPersonAtIndex:(NSUInteger) index;
- (NSString *) followersURL;
- (NSString *) lastLocation;
- (NSUInteger) followingCount;
- (NSUInteger) followersCount;
- (NSURL *) followUserURLForUser;
- (NSString *) followingURL;
- (NSDictionary *) user;
- (NSArray *) people;

- (void) receiveFlaggedNotification:(NSNotification *) notification;

@end
