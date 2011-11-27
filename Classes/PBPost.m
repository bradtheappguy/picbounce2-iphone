//
//  PBPhoto.m
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBPost.h"
#import "ASIFormDataRequest.h"
#import "ASIS3ObjectRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "PBHTTPRequest.h"
#import "PBSharedUser.h"
#import "PBUploadQueue.h"
@implementation NSData(MD5)

- (NSString*)MD5
{
  // Create byte array of unsigned chars
  unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
  
  // Create 16 byte MD5 hash value, store in buffer
  CC_MD5(self.bytes, self.length, md5Buffer);
  
  // Convert unsigned char buffer to NSString of hex values
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
    [output appendFormat:@"%02x",md5Buffer[i]];
  
  return output;
}

@end



@implementation PBPost

@synthesize uploadFailed;
@synthesize uploading;
@synthesize uploadSucceded;
@synthesize uploadProgress;

@synthesize shouldCrossPostToTwitter;
@synthesize shouldCrossPostToFacebook;

@synthesize image = _image;
@synthesize text = _text;

-(id) initWithImage:(UIImage *)image {
  if (self = [super init]) {
    self.uploadProgress = 0;
    self.uploading = YES;
    self.image = image;
  }
  return self;
}

-(id) initWithText:(NSString *)text {
  if (self = [super init]) {
    self.uploadProgress = 0;
    self.uploading = YES;
    self.text = text;
  }
  return self;
}

 
-(void) postToServer {
  NSString *authToken = [(AppDelegate *) [[UIApplication sharedApplication] delegate] authToken];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/posts",API_BASE,authToken]];
  ASIFormDataRequest *postRequest = [PBHTTPRequest formDataRequestWithURL:url];
  [postRequest setShowAccurateProgress:YES];
  [postRequest setUploadProgressDelegate:self];
  [postRequest setRequestMethod:@"POST"];
  [postRequest setPostValue:@"text" forKey:@"media_type"];
  [postRequest setQueue:[PBUploadQueue sharedQueue]];
  
  if (self.image) {
    NSData *jpegData = UIImageJPEGRepresentation(self.image, 0.80);
    NSString *key = [jpegData MD5];
    NSString *originURL = [NSString stringWithFormat:@"http://com.picbounce.incoming.s3.amazonaws.com/photos/%@.jpg",key];
    [postRequest setPostValue:@"photo" forKey:@"media_type"];
    [postRequest setPostValue:originURL forKey:@"origin_url"];
  }
  if (self.shouldCrossPostToTwitter) {
    [postRequest setPostValue:@"1" forKey:@"tw_crosspost"];
  }
  if (self.shouldCrossPostToFacebook) {
    [postRequest setPostValue:@"1" forKey:@"fb_crosspost"];
    NSArray *facebookPages = [PBSharedUser facebookPages];
   
    if ([PBSharedUser shouldCrosspostToFBWall]) {
      [postRequest setPostValue:@"me" forKey:@"fb_crosspost_pages[]"];
    }
    
    
    for (NSDictionary *fbPage in facebookPages) {
      if ([[fbPage objectForKey:@"Selected"] boolValue]) {
        NSString *value = @"";
        NSString *fbid = [fbPage objectForKey:@"id"];
        NSString *fbat = [fbPage objectForKey:@"access_token"];
        value = [value stringByAppendingFormat:@"%@:%@",fbid,fbat];
        [postRequest setPostValue:value forKey:@"fb_crosspost_pages[]"];
      }
    }
    
  }
  if (self.text) {
    [postRequest setPostValue:self.text forKey:@"text"];
  }
  
  [postRequest setDelegate:self];
  [postRequest setDidFinishSelector:@selector(uploadStep2DidFinish:)];
  [postRequest setDidFailSelector:@selector(uploadDidFail:)];
  [postRequest startAsynchronous];
}



-(void)setProgress:(CGFloat)proge {
  NSLog(@"--%f",proge);
  if (proge >= 1.0) {
    if (self.uploadProgress < 0.25) {
       self.uploadProgress = 0.25;
    }
    else {
      self.uploadProgress = 0.75;
    }
   
  }
}

-(void) retry {
  [self startUpload];
}

-(void) startUpload {
  self.uploadFailed = NO;
  self.uploading = YES;
  self.uploadSucceded = NO;
  
  if (self.image) {
    NSData *jpegData = UIImageJPEGRepresentation(self.image, 0.80);
    NSString *key = [[jpegData MD5] stringByAppendingString:@".jpg"];
    key = [@"/photos/" stringByAppendingString:key];
    ASIS3ObjectRequest *req = [ASIS3ObjectRequest PUTRequestForData:jpegData withBucket:@"com.picbounce.incoming" key:key];
    req.uploadProgressDelegate = self;
    [req setShowAccurateProgress:YES];
    [ASIS3Request setSharedSecretAccessKey:@"ylmKXiQObm8CS9OdnhV2Wq9mbrnm0m5LfdeJKvKY"];
    [ASIS3Request setSharedAccessKey:@"AKIAIIZEL3OLHCBIZBBQ"];
    [req setAccessPolicy:@"public-read"];
    [req setMimeType:@"image/jpeg"];
    [req setQueue:[PBUploadQueue sharedQueue]];
    
    
    
    [req setDelegate:self];
    [req setDidFinishSelector:@selector(uploadDidFinish:)];
    [req setDidFailSelector:@selector(uploadDidFail:)];
    [req startAsynchronous];
    
  }
  else {
    [self postToServer];
  }

}

-(void) uploadDidFail:(ASIHTTPRequest *)request {
  self.uploadFailed = YES;
  self.uploading = NO;
  self.uploadSucceded = NO;
}


-(void) uploadDidFinish:(ASIHTTPRequest *)request {
  self.uploadProgress = 0.50f;
  if ([request responseStatusCode] != 200 || [[request responseHeaders] objectForKey:@"X-Amz-Id-2"] == nil) {
    [self uploadDidFail:request];
  }
  else {
    [self postToServer];
  }
}

-(void) uploadStep2DidFinish:(ASIHTTPRequest *)request {
  if (!([request responseStatusCode] == 200 || [request responseStatusCode] == 201)) {
    [self uploadDidFail:request];
  }
  else {
    self.uploadProgress = 1.0f;
    self.uploadFailed = NO;
    self.uploading = NO;
    self.uploadSucceded = YES;
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_DID_UPLOAD" object:nil];
}

-(void) dealloc {
  self.text = nil;
  self.image = nil;
  [super dealloc];
}
@end
