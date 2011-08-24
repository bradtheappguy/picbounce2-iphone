//
//  PBUploadingPhotoTableViewCell.h
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBPhoto.h"

@interface PBUploadingPhotoTableViewCell : UITableViewCell {
  UIProgressView *progeressBar;
  UIButton *retryButton;
  UIButton *deleteButton;
  UILabel *textLabel;
  PBPhoto *_photo;
}


@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIProgressView *progeressBar;
@property (retain, nonatomic) IBOutlet UIButton *retryButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)retryButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
-(void) setPhoto:(PBPhoto *)photo;

@end
