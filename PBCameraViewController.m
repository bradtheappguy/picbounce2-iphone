//
//  PBCameraViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 7/5/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

//TODO extract Toolbar into class


#import "PBCameraViewController.h"
#import "FlashButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASIFormDataRequest.h"
#import "ASIS3ObjectRequest.h"
#import <CommonCrypto/CommonDigest.h>
#define PREVIEW_FRAME


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



@implementation PBCameraViewController

-(void) viewDidLoad {
  filterScrollView.contentSize = filterScrollView.bounds.size;
  filterScrollView.alwaysBounceHorizontal = YES;
  self.wantsFullScreenLayout = YES;
  [super viewDidLoad];
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  self.view.frame = CGRectMake(0, 0, 320, 480);
  
  flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [flipButton setBackgroundImage:[UIImage imageNamed:@"btn_flip_n"] forState:UIControlStateNormal];
  [flipButton addTarget:self action:@selector(flipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  flipButton.frame = CGRectMake(320-71-5, 5, 71, 37);
  [self.view addSubview:flipButton];
  
  flashButton = [FlashButton button];
   [flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:flashButton];
  
  HDRButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [HDRButton setBackgroundImage:[UIImage imageNamed:@"btn_hdr_n"] forState:UIControlStateNormal];
  [HDRButton addTarget:self action:@selector(hdrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  HDRButton.frame = CGRectMake((320/2) - (95/2), 5, 95, 37);
 // [self.view addSubview:HDRButton];
  
  queue = dispatch_queue_create("com.picbounce.internalqueue", NULL);
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  

  
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  if (UIDeviceOrientationIsLandscape(orientation)) {
    NSLog(@" ");
  }
  else {
    NSLog(@" ");
  }
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  [[self.tabBarController tabBar] setAlpha:0];
  
  CALayer *previewLayer = [[CaptureSessionManager sharedManager] previewLayer];
  //CGRect bounds = [previewLayer bounds];
  
  CGFloat width  = 320.0f;
  CGRect layerRect = CGRectMake(0, 0, width, 426);
  
  if ([[[CaptureSessionManager sharedManager] captureSession] isRunning] == NO) {
    [[[CaptureSessionManager sharedManager] captureSession] startRunning];  
  }
  [previewLayer setBounds:layerRect];
  [previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
  [(id)previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
  [[self.view layer] insertSublayer:previewLayer atIndex:0];
  
}

-(IBAction) cameraButtonPressed:(id)sender {
  [[CaptureSessionManager sharedManager] capturePhotoWithCompletionHandler:
   ^(CMSampleBufferRef ref, NSError *error) {
     dispatch_async(queue, ^(void) {
       sleep(5);
       NSLog(@"I took a photo.");  
     });
   }];
  
}

-(void) cancelButtonPressed:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(void) flashButtonPressed:(id)sender {
  
}

-(void) flipButtonPressed:(id)sender {
  BOOL x = [[CaptureSessionManager sharedManager] flip];
  x = x;
}

-(void) hdrButtonPressed:(id)sender {
  
}

-(void) optionsButtonPressed:(id)sender {
  UIViewController *viewCOntroller = [[UIViewController alloc] init];
  [self.navigationController pushViewController:viewCOntroller animated:YES];
  [viewCOntroller release];
}

-(void) dealloc {
  [super dealloc];
  dispatch_release(queue);
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  NSData *jpegData = UIImageJPEGRepresentation(image, 0.80);

  
  NSString *key = [[jpegData MD5] stringByAppendingString:@".jpg"];
  ASIS3ObjectRequest *req = [ASIS3ObjectRequest PUTRequestForData:jpegData withBucket:@"com.picbounce.incoming" key:key];

  [ASIS3Request setSharedSecretAccessKey:@"ylmKXiQObm8CS9OdnhV2Wq9mbrnm0m5LfdeJKvKY"];
  [ASIS3Request setSharedAccessKey:@"AKIAIIZEL3OLHCBIZBBQ"];
  [req setMimeType:@"image/jpeg"];
  [req setDelegate:self];
  [req setDidFinishSelector:@selector(uploadDidFinish:)];
  [req setDidFailSelector:@selector(uploadDidFail:)];
  [req startAsynchronous];
  
  NSLog(@"%@",req.responseString);

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
  NSString *authToken = [[[UIApplication sharedApplication] delegate] authToken];
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
}

-(void) uploadDidFail:(ASIHTTPRequest *)request {
    NSLog(@" ");
}



/*
To upload a file
 
#1 Resize to max 600x600
#2 Convert to JPEG
#3 Save MD5 as (DeviceID + timestamp + JPEGData)
#4 Upload To Amazon AWS
 
 
*/

@end
