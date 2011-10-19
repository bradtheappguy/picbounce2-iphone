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
#import "PBFilteredImage.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "PBUploadQueue.h"

//#import "CaptureSessionManager.h"
#import "AppDelegate.h"

#import "AFFeatherController.h"


UIImage *scaleAndRotateImage(UIImage *image)
{
  int kMaxResolution = 900; // Or whatever
  
  CGImageRef imgRef = image.CGImage;
  
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  CGRect bounds = CGRectMake(0, 0, width, height);
  if (width > kMaxResolution || height > kMaxResolution) {
    CGFloat ratio = width/height;
    if (ratio > 1) {
      bounds.size.width = kMaxResolution;
      bounds.size.height = bounds.size.width / ratio;
    }
    else {
      bounds.size.height = kMaxResolution;
      bounds.size.width = bounds.size.height * ratio;
    }
  }
  
  CGFloat scaleRatio = bounds.size.width / width;
  CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
  CGFloat boundHeight;
  UIImageOrientation orient = image.imageOrientation;
  switch(orient) {
      
    case UIImageOrientationUp: //EXIF = 1
      transform = CGAffineTransformIdentity;
      break;
      
    case UIImageOrientationUpMirrored: //EXIF = 2
      transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      break;
      
    case UIImageOrientationDown: //EXIF = 3
      transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationDownMirrored: //EXIF = 4
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0);
      break;
      
    case UIImageOrientationLeftMirrored: //EXIF = 5
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
      
    case UIImageOrientationLeft: //EXIF = 6
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
      
    case UIImageOrientationRightMirrored: //EXIF = 7
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeScale(-1.0, 1.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
      
    case UIImageOrientationRight: //EXIF = 8
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
      
    default:
      [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
      
  }
  
  UIGraphicsBeginImageContext(bounds.size);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  }
  else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }
  
  CGContextConcatCTM(context, transform);
  
  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
  UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return imageCopy;
}



#define PREVIEW_FRAME
static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";
static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};







@implementation PBCameraViewController

@synthesize unfilteredImage;

- (UIImage*) getSubImageFrom: (UIImage*) img WithRect: (CGRect) rect {
  
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // translated rectangle for drawing sub image 
  CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
  
  // clip to the bounds of the image context
  // not strictly necessary as it will get clipped anyway?
  CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
  
  // draw image
  [img drawInRect:drawRect];
  
  // grab image
  UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return subImage;
}

-(void) closeShutter {
  if (!flashView)
    flashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 426)];
  flashView.backgroundColor = [UIColor clearColor];
  flashView.image = [UIImage imageNamed:@"bg_shutter_13"];
  flashView.animationImages = [NSArray arrayWithObjects: 
                               [UIImage imageNamed:@"bg_shutter_1"],
                               [UIImage imageNamed:@"bg_shutter_2"],
                               [UIImage imageNamed:@"bg_shutter_3"],
                               [UIImage imageNamed:@"bg_shutter_4"],
                               [UIImage imageNamed:@"bg_shutter_5"],
                               [UIImage imageNamed:@"bg_shutter_6"],
                               [UIImage imageNamed:@"bg_shutter_7"],
                               [UIImage imageNamed:@"bg_shutter_8"],
                               [UIImage imageNamed:@"bg_shutter_9"],
                               [UIImage imageNamed:@"bg_shutter_10"],
                               [UIImage imageNamed:@"bg_shutter_11"],
                               [UIImage imageNamed:@"bg_shutter_12"],
                               [UIImage imageNamed:@"bg_shutter_13"],
                               nil];
  
  flashView.animationRepeatCount = 1;
  flashView.animationDuration = 0.33;
  [flashView startAnimating];
  [[self view] addSubview:flashView];
}

- (void) openShutter {  
  //[flashView removeFromSuperview];
  //[flashView release];
  //flashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 425)];
  flashView.image = [UIImage imageNamed:@"bg_shutter_0"];
  flashView.animationImages = [NSArray arrayWithObjects: 
                               [UIImage imageNamed:@"bg_shutter_13"],
                               [UIImage imageNamed:@"bg_shutter_12"],
                               [UIImage imageNamed:@"bg_shutter_11"],
                               [UIImage imageNamed:@"bg_shutter_10"],
                               [UIImage imageNamed:@"bg_shutter_9"],
                               [UIImage imageNamed:@"bg_shutter_8"],
                               [UIImage imageNamed:@"bg_shutter_7"],
                               [UIImage imageNamed:@"bg_shutter_6"],
                               [UIImage imageNamed:@"bg_shutter_5"],
                               [UIImage imageNamed:@"bg_shutter_4"],
                               [UIImage imageNamed:@"bg_shutter_3"],
                               [UIImage imageNamed:@"bg_shutter_2"],
                               [UIImage imageNamed:@"bg_shutter_1"],
                               [UIImage imageNamed:@"bg_shutter_0"],
                               nil];
  
  flashView.animationRepeatCount = 1;
  flashView.animationDuration = 0.33;
  [flashView startAnimating];
  //[[[self view] window] addSubview:flashView];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( context == AVCaptureStillImageIsCapturingStillImageContext ) {
		BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if ( isCapturingStillImage ) {
			// Flash animation
			
		}
		else {
      [UIView animateWithDuration:0.4f 
                            delay:0.4f 
                          options:0 
                       animations:^{
                           [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                                    cameraToolbar.center = CGPointMake(cameraToolbar.center.x - 320, cameraToolbar.center.y);
                         flipButton.alpha = 0;
                         flashButton.alpha = 0;
                                  }
                       completion:^(BOOL finished){
                         [self openShutter];
                       }
			 ];

	}
}
}


- (void)teardownAVCapture
{
	[videoDataOutput release];
	if (videoDataOutputQueue)
		dispatch_release(videoDataOutputQueue);
	[stillImageOutput removeObserver:self forKeyPath:@"isCapturingStillImage"];
	[stillImageOutput release];
	[previewLayer removeFromSuperlayer];
	[previewLayer release];
}

- (void)setupAVCapture
{
	NSError *error = nil;
	
	session = [AVCaptureSession new];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
	else
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];  [deviceInput retain];
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
	[videoDataOutput setSampleBufferDelegate:(id)self queue:videoDataOutputQueue];
	if ( [session canAddOutput:videoDataOutput] )
		[session addOutput:videoDataOutput];
 
  
  NSArray *connections = [videoDataOutput connections];
  for (AVCaptureConnection *connection in connections) {
    [connection setEnabled:YES];
  }
  
  
	//[[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
	
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

-(void) filterButtonPressed:(UIButton *)sender {
  if (sender.tag == -1) {
    uploadPreviewImage.image = unfilteredImage;
  }
  else {
    NSString *filterName = [[PBFilteredImage availableFilters] objectAtIndex:sender.tag];
    uploadPreviewImage.image = [PBFilteredImage filteredImageWithImage:unfilteredImage filter:filterName];
  }
}

-(void) configureFilterScrollView {
  CGFloat x = 0;
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(0, 0, 58, 58);
  button.center = CGPointMake(((58/2) + 2), filterScrollView.frame.size.height/2);
  button.tag = -1;
[filterScrollView addSubview:button];
  
  for (NSString *filterName in [PBFilteredImage availableFilters]) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 58, 58);
    button.center = CGPointMake(((58/2) + 2)+(60*(x+1)), filterScrollView.frame.size.height/2);
    button.tag = x;
    x++;
    [filterScrollView addSubview:button];
  }
  filterScrollView.contentSize = filterScrollView.bounds.size;
  filterScrollView.alwaysBounceHorizontal = YES;
}

-(void) viewDidLoad {
  [self configureFilterScrollView];
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
  flashButton.delegate = self;
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

-(void) viewDidAppear:(BOOL)animated {
  [self openShutter];
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
  
  flashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 426)];
  flashView.image = [UIImage imageNamed:@"bg_shutter_13"];
  [self.view addSubview:flashView];
  
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
  [self closeShutter];
  // Find out the current orientation and tell the still image output.
  AVCaptureConnection *stillImageConnection = nil;
  for (AVCaptureConnection *connection in stillImageOutput.connections) {
    stillImageConnection = connection;
    break;
  }
	//AVCaptureConnection *stillImageConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
	UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
	AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
	[stillImageConnection setVideoOrientation:avcaptureOrientation];
	
  [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG 
                                                                    forKey:AVVideoCodecKey]]; 
	
	[stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                  if (error) {
                                                  }
                                                  NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                  UIImage *image = [[UIImage alloc] initWithData:jpegData];
                                                  
                                                  UIImage *scaledImage = scaleAndRotateImage(image);
                                                  
                                                  [image release];
                                                  CGImageRef scaledCGImage = CGImageCreateWithImageInRect([scaledImage CGImage],CGRectMake(0, 0, 600, 600));
                                                  UIImage *i3 = [UIImage imageWithCGImage:scaledCGImage];
                                                  CGImageRelease(scaledCGImage);
                                                  
                                                  self.unfilteredImage = i3;
                                                 
                                                  uploadPreviewImage.contentMode = UIViewContentModeScaleAspectFit;
                                                  uploadPreviewImage.image = i3;
                                                  uploadPreviewImage.layer.masksToBounds = NO;
                                                  uploadPreviewImage.layer.cornerRadius = 0;
                                                  uploadPreviewImage.layer.shadowOffset = CGSizeMake(0, 0);
                                                  uploadPreviewImage.layer.shadowRadius = 4;
                                                  uploadPreviewImage.layer.shadowOpacity = 1;
                                                  uploadPreviewImage.layer.shadowColor = [UIColor blackColor].CGColor;
                                                  
                                                  CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, 
                                                                                                              imageDataSampleBuffer, 
                                                                                                               kCMAttachmentMode_ShouldPropagate);
                                                  /*ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                                  [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
                                                    if (error) {
                                                      //[self displayErrorOnMainQueue:error withMessage:@"Save to camera roll failed"];
                                                    }
                                                  }];*/
                                                  
                                                  if (attachments)
                                                    CFRelease(attachments);
                                                  //[library release];
                                                }];
}

-(void) cancelButtonPressed:(id)sender {
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
  [self dismissModalViewControllerAnimated:YES];
}

-(void) flashButtonPressed:(id)sender {
  
}


- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  for (AVCaptureDevice *device in devices) {
    if ([device position] == position) {
      return device;
    }
  }
  return nil;
}

- (AVCaptureDevice *) frontFacingCamera
{
  return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *) backFacingCamera
{
  return [self cameraWithPosition:AVCaptureDevicePositionBack];
}


-(void) flipButtonPressed:(id)sender {

  
  if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {
    NSError *error = nil;

    AVCaptureDeviceInput *newVideoInput;
 
    AVCaptureDevicePosition position = [[deviceInput device] position];
    BOOL mirror = NO;
    if (position == AVCaptureDevicePositionBack) {
      newVideoInput = [[[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error] autorelease];
    
    } else if (position == AVCaptureDevicePositionFront) {
      newVideoInput = [[[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error] autorelease];

    } else {
      goto bail;
    }
    
    if (newVideoInput != nil) {
      [session beginConfiguration];
      [session removeInput:deviceInput];
      NSString *currentPreset = [session sessionPreset];
      if (![[newVideoInput device] supportsAVCaptureSessionPreset:currentPreset]) {
        [session setSessionPreset:AVCaptureSessionPresetHigh]; // default back to high, since this will always work regardless of the camera
      }
      if ([session canAddInput:newVideoInput]) {
        [session addInput:newVideoInput];
        AVCaptureConnection *connection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];;
        if ([connection isVideoMirroringSupported]) {
          [connection setVideoMirrored:mirror];
        }
        deviceInput = [newVideoInput retain];
      } 
      else {
        [session setSessionPreset:currentPreset];
        [session addInput:newVideoInput];
      }
      [session commitConfiguration];
      
    } else if (error) {
      NSLog(@"Error");
    }
  }
  
bail:
  return;

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
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
  cameraToolbar.center = CGPointMake(cameraToolbar.center.x - 320, cameraToolbar.center.y);
  flipButton.alpha = 0;
  flashButton.alpha = 0;
  
  [self dismissModalViewControllerAnimated:YES];
  [unfilteredImage release];
  
  unfilteredImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  [unfilteredImage retain];
  
  uploadPreviewImage.image = unfilteredImage;
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

-(IBAction) uploadButtonPressed:(id)sender{
  [[PBUploadQueue sharedQueue] uploadImage:uploadPreviewImage.image];
  
  if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
    [self dismissViewControllerAnimated:YES 
                             completion:^(void) {
                               cameraToolbar.center = CGPointMake(cameraToolbar.center.x + 320, cameraToolbar.center.y);
                               flipButton.alpha = 1;
                               flashButton.alpha = 1;
                               
                             }]; 
  }
    else {
      [self dismissModalViewControllerAnimated:YES];
      cameraToolbar.center = CGPointMake(cameraToolbar.center.x + 320, cameraToolbar.center.y);
      flipButton.alpha = 1;
      flashButton.alpha = 1;

      
    }
 
}


-(IBAction) retakeButtonPressed:(id)sender{
  [UIView animateWithDuration:.4f
                   animations:^{
                       [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                     cameraToolbar.center = CGPointMake(cameraToolbar.center.x + 320, cameraToolbar.center.y);
                     flipButton.alpha = 1;
                     flashButton.alpha = 1;
                   }
                   completion:^(BOOL finished){
                    
                   }
   ];
}

- (BOOL) hasFlash
{
  return [[deviceInput device] hasFlash];
}

- (AVCaptureFlashMode) flashMode
{
  return [[deviceInput device] flashMode];
}

- (void) setFlashMode:(AVCaptureFlashMode)flashMode
{
  AVCaptureDevice *device = [deviceInput device];
  if ([device isFlashModeSupported:flashMode] && [device flashMode] != flashMode) {
    NSError *error;
    if ([device lockForConfiguration:&error]) {
      [device setFlashMode:flashMode];
      [device unlockForConfiguration];
    }    
  }
}

-(void) flashButtonValueDidChange:(FlashButton *)button {
  if (button.mode == FlashButtonModeOff) {
     [self setFlashMode:AVCaptureFlashModeOff];
  }
  else if (button.mode == FlashButtonModeOn) {
    [self setFlashMode:AVCaptureFlashModeOn];
  }
  else if (button.mode == FlashButtonModeAuto) {
    [self setFlashMode:AVCaptureFlashModeAuto];
  }
  else if (button.mode == FlashButtonModeTorch) {
    
  }
}

-(IBAction) photoLibraryButtonPressed:(id)sender {
  UIImagePickerController *photoLibraryPicker = [[UIImagePickerController alloc] init];
  photoLibraryPicker.delegate = self;
  [self presentModalViewController:photoLibraryPicker animated:YES];
  [photoLibraryPicker release];
}
@end
