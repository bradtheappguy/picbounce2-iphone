//
//  PBAPIresponse.m
//  PicBounce2
//
//  Created by BradSmith on 3/1/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBAPIResponse.h"
#import "SBJSON.h"

@implementation PBAPIresponse

-(id) initWithresponseData:(id)json_string {
    if (self = [super init]) {
        SBJSON *parser = [[SBJSON alloc] init];
        data = [[parser objectWithString:json_string error:nil] retain];
      [parser release];
        if ([self validate:data]) {
          posts = [[data objectForKey:@"response"] objectForKey:@"posts"];
          people = [[data objectForKey:@"response"] objectForKey:@"people"];
          user = [[data objectForKey:@"response"] objectForKey:@"user"];
          url = [[data objectForKey:@"response"] objectForKey:@"url"];
          next = [[data objectForKey:@"response"] objectForKey:@"next"];
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
    NSMutableArray *newPosts = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"response"] objectForKey:@"posts"];
    NSMutableArray *newPeople = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"response"] objectForKey:@"people"];
    [posts addObjectsFromArray:newPosts];
    [people addObjectsFromArray:newPeople];
    user = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"response"] objectForKey:@"user"];
    url = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"response"] objectForKey:@"url"];
    next = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"response"] objectForKey:@"next"];
  }
  [parser release];
}

-(NSUInteger) followingCount {
  id x = [[data objectForKey:@"user"] objectForKey:@"following_count"]; 
  return [x intValue];
}

-(NSUInteger) followersCount {
  id x = [[data objectForKey:@"user"] objectForKey:@"followers_count"]; 
  return [x intValue];
}

-(NSUInteger) badgesCount {
  id x = [[data objectForKey:@"user"] objectForKey:@"badges_count"]; 
  return [x intValue];
}

-(NSString *) lastLocation {
  id x = [[data objectForKey:@"user"] objectForKey:@"last_location"]; 
  return x?x:@"";
}



-(NSMutableArray *) posts {
 if (!posts) {
   if ([data isKindOfClass:[NSDictionary class]]) {
     if ([data objectForKey:@"user"]) {
       posts = [[[data objectForKey:@"user"] objectForKey:@"posts"] retain];
     }
     else {
      posts = [[data objectForKey:@"posts"] retain];
    }     
   }
 }
  return posts;
}


-(NSArray *) people {
  if (!people) {
    NSDictionary *response = [data objectForKey:@"response"];
    people = [[response objectForKey:@"users"] retain]; //TODD
  }
  return people;
}


-(NSUInteger) numberOfPhotos {
  return [[self posts] count];
}

-(NSUInteger) numberOfPeople {
  NSArray *p = [self people];
  NSUInteger count = [p count];
  return count;
}


-(NSURL *) loadMoreDataURL {
  return [NSURL URLWithString:next];
}

- (NSDictionary *) photoAtIndex:(NSUInteger) index {
  NSArray *arrayOfPhotos = [self posts];
  if ([arrayOfPhotos count] > index) {
    id photo = [arrayOfPhotos objectAtIndex:index];
    if (([photo objectForKey:@"post"]) && ([photo objectForKey:@"post"] != [NSNull null])) {
      photo = [photo objectForKey:@"post"];
    }
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
    return [person objectForKey:@"user"];
  }
  else {
    return nil;
  }
}


-(NSString *) usernameForPersonAtIndex:(NSUInteger) index {
  NSDictionary *person = [self personAtIndex:index];
  id name =  [person objectForKey:@"display_name"];
  if ([name isEqual:[NSNull null]]) {
    name = @"??";
  }
  return name;
}

- (NSString *) followersURL {
  NSString *urlString = [user objectForKey:@"followed_by_url"]; 
  return urlString;
}

-(NSString *) followingURL {
  NSString *urlString = [user objectForKey:@"follows_url"]; 
  return urlString;
}
    
-(NSURL *)followUserURLForUser {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/me/following",API_BASE]];
}

- (NSDictionary *) user {
  return user;
}
@end
