#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

enum {
  AVCamMirroringOff   = 1,
  AVCamMirroringOn    = 2,
  AVCamMirroringAuto  = 3
};
typedef NSInteger AVCamMirroringMode;


@interface CaptureSessionManager : NSObject  {
  
}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic,assign) AVCamMirroringMode mirroringMode;

+ (id)   sharedManager;
- (void) addVideoPreviewLayer;
- (void) addVideoInput;
- (void) reset;
- (void) capturePhotoWithCompletionHandler:(void (^)(CMSampleBufferRef imageDataSampleBuffer, NSError *error))handler;
- (BOOL) flip;
@end