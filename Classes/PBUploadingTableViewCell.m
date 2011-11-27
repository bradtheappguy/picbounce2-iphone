//
//  PBUploadingPhotoTableViewCell.m
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBUploadingTableViewCell.h"
#import "PBUploadQueue.h"

@implementation PBUploadingTableViewCell

@synthesize imageView;
@synthesize progeressBar;
@synthesize retryButton;
@synthesize deleteButton;
@synthesize textLabel;

- (void)dealloc {
  [_post removeObserver:self forKeyPath:@"uploadFailed"];
  [_post removeObserver:self forKeyPath:@"uploadSucceded"];
  [_post removeObserver:self forKeyPath:@"uploadProgress"];
  
  [imageView release];
  [progeressBar release];
  [retryButton release];
  [deleteButton release];
  [textLabel release];
  [super dealloc];
}

- (IBAction)retryButtonPressed:(id)sender {
  [_post retry];
}

- (IBAction)deleteButtonPressed:(id)sender {
  [[PBUploadQueue sharedQueue] removePost:_post];
}

-(void) setPost:(PBPost *)post {
  if (post == _post) {
    return;
  }
  
  if (_post) {
    [_post removeObserver:self forKeyPath:@"uploadFailed"];
    [_post removeObserver:self forKeyPath:@"uploadSucceded"];
    [_post removeObserver:self forKeyPath:@"uploadProgress"];
    [_post release];
  }
  
  self.retryButton.hidden = YES;
  self.deleteButton.hidden = YES;
  _post = [post retain];
  [_post addObserver:self forKeyPath:@"uploadFailed" options:NSKeyValueChangeSetting context:nil];
  [_post addObserver:self forKeyPath:@"uploadSucceded" options:NSKeyValueChangeSetting context:nil];
  [_post addObserver:self forKeyPath:@"uploadProgress" options:NSKeyValueChangeSetting context:nil];
  
  [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
  
  if (_post.uploadSucceded) {
    [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_6"]];
  }
  else {
    [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_1"]];
  } 
  self.imageView.image = [_post image];
}

-(void) success {
  
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"uploadProgress"]) {
    NSLog(@"xxxx %f",_post.uploadProgress);
    if (_post.uploadProgress >= 1.0) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_6"]];
    else if (_post.uploadProgress >= 0.75) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_5"]];
    else if (_post.uploadProgress >= 0.50) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_4"]];
    else if (_post.uploadProgress >= 0.25) [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_3"]];
    //[self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_2"]];
          
  }
  
  if (_post.uploadFailed) {
    self.retryButton.hidden = NO;
    self.deleteButton.hidden = NO;
    self.progeressBar.hidden = YES;
    self.textLabel.text = @"upload failed";
  }
  else {
    self.retryButton.hidden = YES;
    self.deleteButton.hidden = YES;
    if (_post.uploadSucceded) {
      self.textLabel.text = @"uploaded";
      [self.progeressBar setImage:[UIImage imageNamed:@"bg_pb_6"]];
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
