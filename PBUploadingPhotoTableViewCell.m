//
//  PBUploadingPhotoTableViewCell.m
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBUploadingPhotoTableViewCell.h"

@implementation PBUploadingPhotoTableViewCell

@synthesize imageView;
@synthesize progeressBar;
@synthesize retryButton;
@synthesize deleteButton;
@synthesize textLabel;

- (void)dealloc {
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

-(void) setPhoto:(PBPhoto *)photo {
  _photo = [photo retain];
  [_photo addObserver:self forKeyPath:@"uploadFailed" options:NSKeyValueChangeSetting context:nil];
  [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
  self.imageView.image = [_photo image];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (_photo.uploadFailed) {
    self.retryButton.hidden = NO;
    self.deleteButton.hidden = NO;
    self.progeressBar.hidden = YES;
    self.textLabel.text = @"Upload Failed";
  }
  else {
    self.retryButton.hidden = YES;
    self.deleteButton.hidden = YES;
    if (_photo.uploadSucceded) {
      self.textLabel.text = @"Uploaded";
      self.progeressBar.hidden = YES;
    }
    else {
      self.textLabel.hidden = NO;
      self.textLabel.text = @"Uploading";
      self.progeressBar.hidden = NO;
    }
  }

}
@end
