//
//  PBPhotoView.m
//  PicBounce2
//
//  Created by Brad Smith on 22/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBPhotoView.h"

@implementation PBPhotoView

-(void) awakeFromNib {
  self.backgroundColor = [UIColor blueColor];
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  spinner.center = self.center;
  spinner.hidden = YES;
  [self addSubview:spinner];
  
}


- (void)setImageURL:(NSURL *)aURL {
  [super setImageURL:aURL];
  if (!self.image && aURL) {
    spinner.hidden = NO;
    [spinner startAnimating];
  }
}

- (void)imageLoaderDidLoad:(NSNotification*)notification {
  [super imageLoaderDidLoad:notification];
  spinner.hidden = YES;
  [spinner stopAnimating];
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
  [super imageLoaderDidFailToLoad:notification];
  spinner.hidden = YES;
  [spinner stopAnimating];
}

@end
