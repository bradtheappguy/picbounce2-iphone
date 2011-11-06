//
//  PBUploadingPhotoTableViewCell.m
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBUploadingTableViewCell.h"

@implementation PBUploadingTableViewCell

@synthesize imageView;
@synthesize progeressBar;
@synthesize retryButton;
@synthesize deleteButton;
@synthesize textLabel;

- (void)dealloc {
  [_photo removeObserver:self forKeyPath:@"uploadFailed"];
  [_photo removeObserver:self forKeyPath:@"uploadSucceded"];
  [_photo removeObserver:self forKeyPath:@"uploadProgress"];
  
  [imageView release];
  [progeressBar release];
  [retryButton release];
  [deleteButton release];
  [textLabel release];
  [super dealloc];
}

- (IBAction)retryButtonPressed:(id)sender {
  [_photo retry];
}

- (IBAction)deleteButtonPressed:(id)sender {
}

-(void) setPhoto:(PBPost *)photo {
  self.retryButton.hidden = YES;
  self.deleteButton.hidden = YES;
  _photo = [photo retain];
  [_photo addObserver:self forKeyPath:@"uploadFailed" options:NSKeyValueChangeSetting context:nil];
  [_photo addObserver:self forKeyPath:@"uploadSucceded" options:NSKeyValueChangeSetting context:nil];
  [_photo addObserver:self forKeyPath:@"uploadProgress" options:NSKeyValueChangeSetting context:nil];
  
  [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
  [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_1"]];
  
  self.imageView.image = [_photo image];
}

-(void) success {
  
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"uploadProgress"]) {
    NSLog(@"xxxx %f",_photo.uploadProgress);
    if (_photo.uploadProgress >= 1.0) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_6"]];
    else if (_photo.uploadProgress >= 0.75) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_5"]];
    else if (_photo.uploadProgress >= 0.50) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_4"]];
    else if (_photo.uploadProgress >= 0.25) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_3"]];
    //[self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_2"]];
          
  }
  
  if (_photo.uploadFailed) {
    self.retryButton.hidden = NO;
    self.deleteButton.hidden = NO;
    self.progeressBar.hidden = YES;
    self.textLabel.text = @"upload failed";
  }
  else {
    self.retryButton.hidden = YES;
    self.deleteButton.hidden = YES;
    if (_photo.uploadSucceded) {
      self.textLabel.text = @"uploaded";
    }
    else {
      self.textLabel.hidden = NO;
      self.textLabel.text = @"uploading";
      self.progeressBar.hidden = NO;
    }
  }


}

-(void) hidePreogessBar {
  self.progeressBar.hidden = YES;
}

@end
