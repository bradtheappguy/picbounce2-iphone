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
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>

//#import "CaptureSessionManager.h"
#import "AppDelegate.h"
#define PREVIEW_FRAME
static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";
static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};


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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( context == AVCaptureStillImageIsCapturingStillImageContext ) {
		BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if ( isCapturingStillImage ) {
			// Flash animation
			flashView = [[UIView alloc] initWithFrame:[previewView frame]];
			[flashView setBackgroundColor:[UIColor whiteColor]];
			[flashView setAlpha:0.f];
			[[[self view] window] addSubview:flashView];
			
			[UIView animateWithDuration:.4f
                       animations:^{
                         [flashView setAlpha:1.f];
                       }
			 ];
		}
		else {
			[UIView animateWithDuration:.4f
                       animations:^{
                         [flashView setAlpha:0.f];
                         cameraToolbar.center = CGPointMake(cameraToolbar.center.x - 320, cameraToolbar.center.y);
                       }
                       completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                         [flashView release];
                         flashView = nil;
                       }
			 ];
		}
	}
}




- (void)setupAVCapture
{
	NSError *error = nil;
	
	AVCaptureSession *session = [AVCaptureSession new];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    [session setSessionPreset:AVCaptureSessionPreset640x480];
	else
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	require( error == nil, bail );
	isUsingFrontFacingCamera = NO;
	if ( [session canAddInput:deviceInput] )
		[session addInput:deviceInput];
	
	stillImageOutput = [AVCaptureStillImageOutput new];
	[stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:AVCaptureStillImageIsCapturingStillImageContext];
	if ( [session canAddOutput:stillImageOutput] )
		[session addOutput:stillImageOutput];
	
	videoDataOutput = [AVCaptureVideoDataOutput new];
	
	NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                     [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	[videoDataOutput setVideoSettings:rgbOutputSettings];
	[videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
	videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
	[videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
	if ( [session canAddOutput:videoDataOutput] )
		[session addOutput:videoDataOutput];
	[[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
	
	effectiveScale = 1.0;
	previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	[previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
	[previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
	CALayer *rootLayer = [previewView layer];
	[rootLayer setMasksToBounds:YES];
	[previewLayer setFrame:[rootLayer bounds]];
	[rootLayer addSublayer:previewLayer];
	[session startRunning];
bail:
	[session release];
	if (error) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                        message:[error localizedDescription]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Dismiss" 
                                              otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		[self teardownAVCapture];
	}
}


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
  
  [self setupAVCapture];
  
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  

  /*
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  if (UIDeviceOrientationIsLandscape(orientation)) {
    NSLog(@" ");
  }
  else {
    NSLog(@" ");
  }
   */
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  [[self.tabBarController tabBar] setAlpha:0];
  
 
  
  /*CGRect bounds = [previewLayer bounds];
  
  CGFloat width  = 320.0f;
  CGRect layerRect = CGRectMake(0, 0, width, 426);
  
  */
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
	AVCaptureVideoOrientation result = deviceOrientation;
	if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
		result = AVCaptureVideoOrientationLandscapeRight;
	else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
		result = AVCaptureVideoOrientationLandscapeLeft;
	return result;
}

-(IBAction) cameraButtonPressed:(id)sender {
  // Find out the current orientation and tell the still image output.
	AVCaptureConnection *stillImageConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
	UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
	AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
	[stillImageConnection setVideoOrientation:avcaptureOrientation];
	[stillImageConnection setVideoScaleAndCropFactor:effectiveScale];
	BOOL doingFaceDetection = detectFaces && (effectiveScale == 1.0);
	if (doingFaceDetection)
		[stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA] 
                                                                    forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
	else
		[stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG 
                                                                    forKey:AVVideoCodecKey]]; 
	
	[stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                  if (error) {
                                                  }
                                                }];
}

-(void) cancelButtonPressed:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(void) flashButtonPressed:(id)sender {
  
}

-(void) flipButtonPressed:(id)sender {
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
-(IBAction) closeButtonPressed:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) uploadButtonPressed:(id)sender{}
-(IBAction) retakeButtonPressed:(id)sender{
  [UIView animateWithDuration:.4f
                   animations:^{
                     [flashView setAlpha:0.f];
                     cameraToolbar.center = CGPointMake(cameraToolbar.center.x + 320, cameraToolbar.center.y);
                   }
                   completion:^(BOOL finished){

                   }
   ];
}
@end
