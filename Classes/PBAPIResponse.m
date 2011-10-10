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
          photos = [[data objectForKey:@"response"] objectForKey:@"photos"];
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
    NSMutableArray *newPhotos = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"response"] objectForKey:@"photos"];
    NSMutableArray *newPeople = [(NSDictionary *) [(NSDictionary *) newData objectForKey:@"response"] objectForKey:@"people"];
    [photos addObjectsFromArray:newPhotos];
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
    NSDictionary *response = [data objectForKey:@"response"];
    people = [[response objectForKey:@"users"] retain]; //TODD
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
  if ([arrayOfPhotos count] > index) {
    id photo = [arrayOfPhotos objectAtIndex:index];
    if (([photo objectForKey:@"photo"]) && ([photo objectForKey:@"photo"] != [NSNull null])) {
      photo = [photo objectForKey:@"photo"];
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