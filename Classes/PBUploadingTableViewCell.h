//
//  PBUploadingPhotoTableViewCell.h
//  PicBounce2
//
//  Created by Brad Smith on 22/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBPost.h"

@interface PBUploadingTableViewCell : UITableViewCell {
  UIImageView *progeressBar;
  UIButton *retryButton;
  UIButton *deleteButton;
  UILabel *textLabel;
  PBPost *_post;
}


@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIImageView *progeressBar;
@property (retain, nonatomic) IBOutlet UIButton *retryButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)retryButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (void) setPost:(NSDictionary *)photo;

@end
