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
  if (self = [super init]) {
    data = [[[SBJSON alloc] init] objectWithString:json_string error:nil];
    [data retain];
  }
  return self;
}

-(void) mergeNewResponceData:(id)json_string {
  id photos = [self photos];
  photos = [[NSMutableArray alloc] initWithArray:photos];
  
  SBJSON *newData = [[[SBJSON alloc] init] objectWithString:json_string error:nil];
  NSArray *newPhotos = [newData objectForKey:@"photos"];
  [[self photos] addObjectsFromArray:newPhotos];
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
    
    if (ago < 3600) {  // < 1 hr ago
      dateString = [[NSString stringWithFormat:@"%d", (int)(ago / 60)] stringByAppendingString:@" m"];
    } else if (ago < 3600 * 24) { // < 24 hr ago
      dateString = [[NSString stringWithFormat:@"%d", (int)(ago / 3600)] stringByAppendingString:@"h ago"];
    }
    else if (ago < 3600 * 24 * 7 * 1000) {  // < 7 days
      dateString = [[NSString stringWithFormat:@"%d", (int)(ago / (24*3600))]stringByAppendingString:@" day"];
    }
    return dateString;
  }
  return @"X";
}

-(NSArray *) photos {
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


-(NSString *) loadMoreDataURL {
  id x = [data objectForKey:@"user"];
  if (x) {
    id y = [x objectForKey:@"more_photos_url"];
    if (y) {
      return y;
    }
  }
  return nil;
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

-(NSURL *) followersURL {
  id x = [data objectForKey:@"user"];
  if (x) {
    id y = [x objectForKey:@"followers_url"];
    if (y) {
      return [NSURL URLWithString:y];
    }
  }
  return nil;
}
                    
@end
