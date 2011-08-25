//
//  PBPhoto.m
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBPhoto.h"
#import "ASIFormDataRequest.h"
#import "ASIS3ObjectRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

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



@implementation PBPhoto

@synthesize uploadFailed;
@synthesize uploading;
@synthesize uploadSucceded;
@synthesize uploadProgress;

@synthesize image;

-(id) initWithImage:(UIImage *)image {
  if (self = [super init]) {
    [self performSelector:@selector(foo) withObject:nil afterDelay:4];
    self.uploading = YES;
    self.image = image;
  }
  return self;
}

-(void) foo {
  self.uploadFailed = YES;
  self.uploading = NO;
  self.uploadSucceded = NO;
}

-(void) bar {
  self.uploadSucceded = YES;
  self.uploadFailed = NO;
  self.uploading = NO;
  
}

-(void) retry {
  NSData *jpegData = UIImageJPEGRepresentation(self.image, 0.80);
  
  
  
  NSString *key = [[jpegData MD5] stringByAppendingString:@".jpg"];
  
  
  ASIS3ObjectRequest *req = [ASIS3ObjectRequest PUTRequestForData:jpegData withBucket:@"com.picbounce.incoming" key:key];
  [ASIS3Request setSharedSecretAccessKey:@"ylmKXiQObm8CS9OdnhV2Wq9mbrnm0m5LfdeJKvKY"];
  [ASIS3Request setSharedAccessKey:@"AKIAIIZEL3OLHCBIZBBQ"];
  [req setAccessPolicy:@"public-read"];
  [req setMimeType:@"image/jpeg"];
  
  
  
  
  [req setDelegate:self];
  [req setDidFinishSelector:@selector(uploadDidFinish:)];
  [req setDidFailSelector:@selector(uploadDidFail:)];
  [req startAsynchronous];
  
  self.uploadFailed = NO;
  self.uploading = YES;
  self.uploadSucceded = NO;
}

-(void) uploadDidFail:(ASIHTTPRequest *)request {
  NSLog(@" ");
}

/*
 create({:photo => params[:photo], 
 :code => code,
 :twitter_oauth_token =>  params[:twitter_oauth_token],
 :twitter_oauth_secret => params[:twitter_oauth_secret],
 :facebook_access_token => (params[:facebook_access_token]?(params[:facebook_access_token].split('&')[0]):nil),  #this split is there to fix a big in iPhone Client version 1.2
 :caption => params[:caption],
 :user_agent => request.user_agent,
 :device_type => params[:system_model],
 :os_version =>  params[:system_version],
 :device_id => params[:device_id],
 :ip_address => request.env['HTTP_X_REAL_IP'],
 :filter_version => params[:filter_version],
 :filter_name => params[:filter_name]
 */
-(void) uploadDidFinish:(ASIHTTPRequest *)request {
  if ([request responseStatusCode] != 200 || [[request responseHeaders] objectForKey:@"x-amz-id-2"] == nil) {
    [self uploadDidFail:request];
  }
  
  
  NSString *authToken = [(AppDelegate *) [[UIApplication sharedApplication] delegate] authToken];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/photos?auth_token=%@",API_BASE,authToken]];
  
  
  ASIFormDataRequest *postRequest = [[ASIFormDataRequest alloc] initWithURL:url];
  [postRequest setRequestMethod:@"POST"];
  [postRequest setPostValue:@"Caption" forKey:@"caption"];
  [postRequest setPostValue:@"1" forKey:@"device_type"];
  [postRequest setPostValue:@"3" forKey:@"os_version"];
  [postRequest setPostValue:@"3" forKey:@"device_id"];
  [postRequest setPostValue:@"2" forKey:@"filter_name"];
  [postRequest setPostValue:@"1" forKey:@"filter_version"];
  [postRequest startAsynchronous];
  [postRequest release];
}



@end
