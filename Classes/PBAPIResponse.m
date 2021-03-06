//
//  PBAPIresponse.m
//  PicBounce2
//
//  Created by BradSmith on 3/1/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBAPI.h"
#import "PBAPIResponse.h"
#import "SBJSON.h"
#import "NSDictionary+NotNull.h"

@implementation PBAPIresponse

@synthesize next = _next;

-(id) initWithresponseData:(id)json_string {
    if (self = [super init]) {
        SBJSON *parser = [[SBJSON alloc] init];
        data = [[parser objectWithString:json_string error:nil] retain];
      [parser release];
        if ([self validate:data]) {
          NSDictionary *response = [data objectForKeyNotNull:@"response"];
          posts = [[response objectForKeyNotNull:@"posts"] objectForKeyNotNull:@"items"];
          people = [response objectForKeyNotNull:@"people"];
          user = [response objectForKeyNotNull:@"user"];
          //url = [[data objectForKey:@"response"] objectForKey:@"url"];
          if ([posts count] > 0) {
            _next = [[[response objectForKeyNotNull:@"posts"] objectForKeyNotNull:@"next"] retain];
          }
          else {
            _next = nil;
          }
        }
    }
    return self;
}

-(BOOL) validate:(id)_data {
    if (![[_data class] isSubclassOfClass:[NSDictionary class]]) {
        return NO;
    }
  return YES;
}


-(void) mergeNewresponseData:(id)json_string {
 // id _photos = [[NSMutableArray alloc] initWithArray:[self photos]];
  SBJSON *parser = [[SBJSON alloc] init];
  
  id newData = [parser objectWithString:json_string error:nil];
  if ([self validate:newData]) {
    NSMutableArray *newPosts = [[(NSDictionary *) [(NSDictionary *) newData objectForKeyNotNull:@"response"] objectForKeyNotNull:@"posts"] objectForKeyNotNull:@"items"];;
    NSMutableArray *newPeople = [[(NSDictionary *) [(NSDictionary *) newData objectForKeyNotNull:@"response"] objectForKeyNotNull:@"people"] objectForKeyNotNull:@"items"];;
    [posts addObjectsFromArray:newPosts];
    [people addObjectsFromArray:newPeople];
    user = [[(NSDictionary *) [(NSDictionary *) newData objectForKeyNotNull:@"response"] objectForKeyNotNull:@"user"] retain];
    url = [[(NSDictionary *) [[(NSDictionary *) newData objectForKeyNotNull:@"response"] objectForKeyNotNull:@"posts"] objectForKeyNotNull:@"url"] retain];
    if ([newPosts count] > 0) {
       _next = [[(NSDictionary *) [[(NSDictionary *) newData objectForKeyNotNull:@"response"] objectForKeyNotNull:@"posts"] objectForKeyNotNull:@"next"] retain];
    }
    else {
      _next = nil;
    }
   
  }
  [parser release];
}

-(NSUInteger) followingCount {
  id x = [[data objectForKeyNotNull:@"user"] objectForKeyNotNull:@"following_count"]; 
  return [x intValue];
}

-(NSUInteger) followersCount {
  id x = [[data objectForKeyNotNull:@"user"] objectForKeyNotNull:@"follower_count"]; 
  return [x intValue];
}

-(NSUInteger) badgesCount {
  id x = [[data objectForKeyNotNull:@"user"] objectForKeyNotNull:@"badges_count"]; 
  return [x intValue];
}

-(NSString *) lastLocation {
  id x = [[data objectForKeyNotNull:@"user"] objectForKeyNotNull:@"last_location"]; 
  return x?x:@"";
}



-(NSMutableArray *) posts {
 if (!posts) {
   if ([data isKindOfClass:[NSDictionary class]]) {
     if ([data objectForKey:@"user"]) {
       posts = [[[data objectForKeyNotNull:@"user"] objectForKeyNotNull:@"posts"] retain];
     }
     else {
      posts = [[data objectForKeyNotNull:@"posts"] retain];
    }     
   }
 }
  return posts;
}


-(NSArray *) people {
  if (!people) {
    NSDictionary *response = [data objectForKey:@"response"];
    people = [[response objectForKeyNotNull:@"users"] retain]; //TODD
  }
  return people;
}


-(NSUInteger) numberOfPosts {
  return [[self posts] count];
}

-(NSUInteger) numberOfPeople {
  NSArray *p = [self people];
  NSUInteger count = [p count];
  return count;
}


-(NSURL *) loadMoreDataURL {
  return [NSURL URLWithString:_next];
}

- (NSDictionary *) photoAtIndex:(NSUInteger) index {
  NSArray *arrayOfPhotos = [self posts];
  if ([arrayOfPhotos count] > index) {
    id photo = [arrayOfPhotos objectAtIndex:index];
    photo = [photo objectForKeyNotNull:@"item"];
    return photo;
  }
  else {
    return nil;
  }
}


-(NSDictionary *) personAtIndex:(NSUInteger) index {
  NSArray *arrayOfUsers = [self people];
  if ([arrayOfUsers count] >= index) {
    NSDictionary *person = [arrayOfUsers objectAtIndex:index];
    return [person objectForKeyNotNull:@"user"];
  }
  else {
    return nil;
  }
}


-(NSString *) usernameForPersonAtIndex:(NSUInteger) index {
  NSDictionary *person = [self personAtIndex:index];
  id name =  [person objectForKeyNotNull:@"name"];
  return name;
}

- (NSString *) followersURL {
  NSString *urlString = [user objectForKeyNotNull:@"followed_by_url"]; 
  return urlString;
}

-(NSString *) followingURL {
  NSString *urlString = [user objectForKeyNotNull:@"follows_url"]; 
  return urlString;
}
    
-(NSURL *)followUserURLForUser {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/me/following",API_BASE]];
}

- (NSDictionary *) user {
  return user;
}


@end
