//
//  PBAPIResponce.m
//  PicBounce2
//
//  Created by BradSmith on 3/1/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBAPIResponce.h"
#import "SBJSON.h"

@implementation PBAPIResponce

-(id) initWithResponceData:(id)json_string {
    if (self == [super init]) {
        data = [[[SBJSON alloc] init] objectWithString:json_string error:nil];
        [data retain];
        if ([self validate:data]) {
          photos = [[data objectForKey:@"responce"] objectForKey:@"photos"];
          people = [[data objectForKey:@"responce"] objectForKey:@"people"];
          user = [[data objectForKey:@"responce"] objectForKey:@"user"];
          url = [[data objectForKey:@"responce"] objectForKey:@"url"];
          next = [[data objectForKey:@"responce"] objectForKey:@"next"];
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


-(void) mergeNewResponceData:(id)json_string {
 // id _photos = [[NSMutableArray alloc] initWithArray:[self photos]];
  
  SBJSON *newData = [[[SBJSON alloc] init] objectWithString:json_string error:nil];
  [newData retain];
  if ([self validate:newData]) {
    NSMutableArray *newPhotos = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"responce"] objectForKey:@"photos"];
    NSMutableArray *newPeople = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"responce"] objectForKey:@"people"];
    [photos addObjectsFromArray:newPhotos];
    [people addObjectsFromArray:newPeople];
    user = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"responce"] objectForKey:@"user"];
    url = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"responce"] objectForKey:@"url"];
    next = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"responce"] objectForKey:@"next"];
  }
  
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

-(NSString *)timeLabelTextForPhotoAtIndex:(NSUInteger)index {
  NSDictionary *photo = [self photoAtIndex:index]; 
  if (photo) {
    id x = [photo objectForKey:@"created"];
    NSUInteger timestamp = [x intValue];
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
  return @"X";
}

-(NSMutableArray *) photos {
 if (!photos) {
   if ([data isKindOfClass:[NSDictionary class]]) {
     if ([data objectForKey:@"user"]) {
       photos = [[[data objectForKey:@"user"] objectForKey:@"photos"] retain];
     }
     else {
      photos = [[data objectForKey:@"photos"] retain];
    }     
   }
 }
  return photos;
}


-(NSArray *) people {
  if (!people) {
    people = [[data objectForKey:@"users"] retain]; //TODD
  }
  return people;
}


-(NSUInteger) numberOfPhotos {
  return [[self photos] count];
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
  NSArray *arrayOfPhotos = [self photos];
  if ([arrayOfPhotos count] >= index) {
    return [arrayOfPhotos objectAtIndex:index];
  }
  else {
    return nil;
  }
}


-(NSDictionary *) personAtIndex:(NSUInteger) index {
  NSArray *arrayOfUsers = [self people];
  if ([arrayOfUsers count] >= index) {
    return [arrayOfUsers objectAtIndex:index];
  }
  else {
    return nil;
  }
}


-(NSString *) usernameForPersonAtIndex:(NSUInteger) index {
  NSDictionary *person = [self personAtIndex:index];
  id name =  [person objectForKey:@"twitter_screen_name"];
  if ([name isEqual:[NSNull null]]) {
    name = @"??";
  }
  return name;
}

- (NSURL *) followersURL {
  id x = user;
  if (x) { 
    id y = [x objectForKey:@"followers_url"]; 
    if (y) {
      return [NSURL URLWithString:y];
    }
  }
  return nil;
}

-(NSURL *) followingURL {
  id x = user;
  if (x) { 
    id y = [x objectForKey:@"following_url"]; 
    if (y) {
      return [NSURL URLWithString:y];
    }
  }
  return nil;
}
    
-(NSURL *)followUserURLForUser {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/me/following",API_BASE]];
}
@end
