//
//  PBNewCameraViewController.m
//  test
//
//  Created by Brad Smith on 11/12/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBNewCameraViewController.h"
#import "PBNewFilterViewController.h"
#import <AVFoundation/AVFoundation.h>
@implementation PBNewCameraViewController

- (id)init {
  self = [super init];
  if (self) {
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.delegate = self;
    self.allowsEditing = NO;
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [(id)[self navigationBar] setStyle:1];
  self.view.backgroundColor = [UIColor blackColor];
  self.delegate = self;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(log:) name:nil object:nil];  
  [self nextViewController];
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  UIViewController *top = [self topViewController];
  UIView *view = top.view;
  for (UIView *v in view.subviews) {
    NSLog(@"%@",v);
  }
}



-(UIView *) customCameraToolbar {
  UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
  v.image = [UIImage imageNamed:@"bg_capture_tabbar"];
  v.userInteractionEnabled = YES;
  
  UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
  cancel.frame = CGRectMake(10, 10, 43, 30);
  [cancel setBackgroundImage:[UIImage imageNamed:@"btn_capture_cancel_n.png"] forState:UIControlStateNormal];
  [cancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [v addSubview:cancel];
  
  UIButton *library = [UIButton buttonWithType:UIButtonTypeCustom];
  library.frame = CGRectMake(62, 10, 42, 30);
  [library addTarget:self action:@selector(libraryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [library setBackgroundImage:[UIImage imageNamed:@"btn_camRoll_n.png"] forState:UIControlStateNormal];
  [v addSubview:library];
  
  
  UIButton *takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
  takePhoto.frame = CGRectMake(110, 3, 100, 46);
  [takePhoto addTarget:self action:@selector(takePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [takePhoto setImage:[UIImage imageNamed:@"btn_capture_n.png"] forState:UIControlStateNormal];
  [takePhoto setAccessibilityLabel:@"Take Photo Button"];
  
  [takePhoto setBackgroundImage:[UIImage imageNamed:@"btn_bg_capture_upload_n@2x.png"] forState:UIControlStateNormal];
  [v addSubview:takePhoto];
  
  return v;
}


-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  UIImageView *overlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 426)];
  overlay.image = [UIImage imageNamed:@"bg_photo_crop.png"];
  overlay.hidden = YES;
  self.cameraOverlayView = overlay;
  
  UIViewController *top = [self topViewController];
  UIView *view = top.view;
  for (UIView *v in view.subviews) {
    for (UIView *v2 in v.subviews) {
      if (v2.frame.size.height == 53) {
        [v2 addSubview:[self customCameraToolbar]];
      }
    }
  }
}


- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) takePictureButtonPressed:(id)sendrd {
  self.delegate = self;
  [self takePicture];
  //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"Recorder_PhotoStillImageSampleBufferReady" object:nil];
}


-(PBNewFilterViewController *) nextViewController {
  static dispatch_once_t once;
  static PBNewFilterViewController *newPostViewController;
  dispatch_once(&once, ^ { newPostViewController = [[PBNewFilterViewController alloc] initWithNibName:@"PBNewFilterViewController" bundle:nil]; [newPostViewController view];});
  return newPostViewController;
}


- (void)log:(NSNotification *)note { 
  //NSLog(@"%@",note);
  if ([note.name isEqualToString:@"UIViewAnimationDidCommitNotification"]) {
    NSDictionary *userInfo = [note userInfo];
    
    //IOS 5 (delegate is not set in ios4)
    if ([[userInfo objectForKey:@"name"] isEqualToString:@"openIris"]) {
      UIView *delegate = [userInfo objectForKey:@"delegate"];
      self.cameraOverlayView.hidden = NO;
      [delegate addSubview:self.cameraOverlayView];
    }
  }
  
  if ([note.name isEqualToString:@"PLCameraViewIrisAnimationWillBeginNotification"]) {
    UIView *delegate = note.object;
    self.cameraOverlayView.hidden = NO;
    [delegate addSubview:self.cameraOverlayView];
  }
  
  if ([note.name isEqualToString:@"Recorder_DidCapturePhoto"]) {
    self.showsCameraControls = NO;
  }
  if ([note.name isEqualToString:@"Recorder_PhotoStillImageSampleBufferReady"]) {
    NSDictionary *userInfo = note.userInfo;
    CMSampleBufferRef x = (CMSampleBufferRef)[userInfo objectForKey:@"Recorder_StillImageSampleBuffer"];
    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:x];
    
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    PBNewFilterViewController *newPostViewController = [self nextViewController];
    newPostViewController.imageView.image = image;
    [image release];
    newPostViewController.hidesBottomBarWhenPushed = YES;
    newPostViewController.navigationItem.title = @"Post";
    [newPostViewController view];
    [self pushViewController:newPostViewController animated:YES];
    [PBNewPostViewController release];
  }
}

-(void) goNext {
 
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *oringialImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

  if (picker == libraryPicker) {
    PBNewFilterViewController *newPostViewController = [self nextViewController];
    newPostViewController.imageView.image = oringialImage;
    [self pushViewController:newPostViewController animated:NO];
    [self dismissModalViewControllerAnimated:YES];
    return;
  }
  
  PBNewFilterViewController *newPostViewController = [self nextViewController];
  if (newPostViewController.imageView.image != nil) {
    return;
  }
  
  newPostViewController.imageView.image = oringialImage;
  NSLog(@"didFinishPickingMediaWithInfo: %@",info);
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  [self viewDidAppear:YES];
}


-(void) cancelButtonPressed:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(void) libraryButtonPressed:(id)sender {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
  if (!libraryPicker) {
    libraryPicker = [[UIImagePickerController alloc] init];
  }
  libraryPicker.view.backgroundColor = [UIColor blackColor];
  libraryPicker.topViewController.view.backgroundColor = [UIColor blackColor];
  libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [[libraryPicker navigationBar] setStyle:1];
  libraryPicker.delegate = self;
  [self presentModalViewController:libraryPicker animated:YES];
}
@end
