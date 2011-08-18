#import "CaptureSessionManager.h"

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize mirroringMode;
@synthesize videoInput = _videoInput;

#pragma mark Capture Session Configuration
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
{
	for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			//if ( [[port mediaType] isEqual:mediaType] ) {
				return [[connection retain] autorelease];
			//}
		}
	}
	return nil;
}


- (id)init {
	if ((self = [super init])) {
		
	}
	return self;
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

- (AVCaptureDevice *) audioDevice
{
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
  if ([devices count] > 0) {
    return [devices objectAtIndex:0];
  }
  return nil;
}


- (AVCaptureSession *)captureSession {
  if (!captureSession) {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setCaptureSession:session];
    [[self captureSession] setSessionPreset:AVCaptureSessionPresetPhoto];
    [session release];
  }
  return captureSession;
}

static CaptureSessionManager *sharedInstance = nil;

+ (id) sharedManager {
  if (!sharedInstance) {
    sharedInstance = [[CaptureSessionManager alloc] init];
  } 
  return sharedInstance;
}

- (void)addVideoPreviewLayer {
  [self setPreviewLayer:[[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]] autorelease]];
  [[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspect];
}

- (void)addVideoInput {
  AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if (videoDevice) {
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if (!error) {
			if ([[self captureSession] canAddInput:videoIn]) {
				[[self captureSession] addInput:videoIn];
        [self setVideoInput:videoIn];
      }
			else {
				NSLog(@"Couldn't add video input");
        self.captureSession = nil;
      }
		}
		else {
			NSLog(@"Couldn't create video input w");
      self.captureSession = nil;
    }
    self.stillImageOutput = [[[AVCaptureStillImageOutput alloc] init] autorelease];
    [self.stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey]];
    if ([[self captureSession] canAddOutput:self.stillImageOutput]) {
      [[self captureSession] addOutput:self.stillImageOutput];
    }
    else {
      NSLog(@"Couldn't add still image output");
      self.captureSession = nil;
    }
	}
	else {
		NSLog(@"Couldn't create video capture device");
    self.captureSession = nil;
  }
}

- (void)capturePhotoWithCompletionHandler:(void (^)(CMSampleBufferRef imageDataSampleBuffer, NSError *error))handler {
  AVCaptureConnection *videoConnection = nil;
  for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
      for (AVCaptureInputPort *port in [connection inputPorts]) {
        if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
          videoConnection = connection;
          break;
        }
      }
  }
  [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:handler];
}

- (void)dealloc {
  
  [[self captureSession] stopRunning];
  
  [previewLayer release], previewLayer = nil;
  [captureSession release], captureSession = nil;
  
  [super dealloc];
}

- (void) reset {
 if ([self.captureSession isRunning]) {
   [self.captureSession stopRunning];
 }

  for (AVCaptureOutput *output in  [self.captureSession outputs]) {
    [self.captureSession removeOutput:output];
  }
 
  for (AVCaptureInput *input in  [self.captureSession inputs]) {
    [self.captureSession removeInput:input];
  }
  [[self previewLayer] removeFromSuperlayer];

  self.previewLayer = nil;
  
  self.captureSession = nil;
  self.captureSession = nil;
  sharedInstance = nil;

}

- (NSUInteger) cameraCount
{
  return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}


- (BOOL) flip
{
  BOOL success = NO;
  
  if ([self cameraCount] > 1) {
    NSError *error;
    AVCaptureDeviceInput *videoInput = [self videoInput];
    AVCaptureDeviceInput *newVideoInput;
    AVCaptureDevicePosition position = [[videoInput device] position];
    BOOL mirror;
    if (position == AVCaptureDevicePositionBack) {
      newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
      switch ([self mirroringMode]) {
        case AVCamMirroringOff:
          mirror = NO;
          break;
        case AVCamMirroringOn:
          mirror = YES;
          break;
        case AVCamMirroringAuto:
        default:
          mirror = NO;
          break;
      }
    } else if (position == AVCaptureDevicePositionFront) {
      newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
      switch ([self mirroringMode]) {
        case AVCamMirroringOff:
          mirror = NO;
          break;
        case AVCamMirroringOn:
          mirror = YES;
          break;
        case AVCamMirroringAuto:
        default:
          mirror = YES;
          break;
      }
    } else {
      goto bail;
    }
    
    AVCaptureSession *session = [self captureSession];
    if (newVideoInput != nil) {
      [session beginConfiguration];
      [session removeInput:videoInput];
      NSString *currentPreset = [session sessionPreset];
      if (![[newVideoInput device] supportsAVCaptureSessionPreset:currentPreset]) {
        [session setSessionPreset:AVCaptureSessionPresetHigh]; // default back to high, since this will always work regardless of the camera
      }
      if ([session canAddInput:newVideoInput]) {
        [session addInput:newVideoInput];
        AVCaptureConnection *connection = [CaptureSessionManager connectionWithMediaType:AVMediaTypeVideo fromConnections:nil];
        if ([connection isVideoMirroringSupported]) {
          [connection setVideoMirrored:mirror];
        }
        [self setVideoInput:newVideoInput];
      } else {
        [session setSessionPreset:currentPreset];
        [session addInput:videoInput];
      }
      [session commitConfiguration];
      success = YES;
      [newVideoInput release];
    } else if (error) {
      NSLog(@"Error");
    }
  }
  
bail:
  return success;
}

@end