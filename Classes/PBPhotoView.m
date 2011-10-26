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
  self.backgroundColor = [UIColor clearColor];
//  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//  spinner.center = self.center;
//  spinner.hidden = YES;
//  [self addSubview:spinner];

    progressBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 180, 17)];
    progressBarImageView.center = self.center;
    [self addSubview:progressBarImageView];
    [self bringSubviewToFront:progressBarImageView];
    progressBarImageView.hidden = YES;
    progressBarImageView.image = [UIImage imageNamed:@"bg_pb@2x.png"];
    
    
    
    
}


- (void)setImageURL:(NSURL *)aURL {
  [super setImageURL:aURL];
  if (!self.image && aURL) {
      progressBarImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"bg_pb@2x.png"],
                                              [UIImage imageNamed:@"bg_pb_1@2x.png"],
                                              [UIImage imageNamed:@"bg_pb_2@2x.png"],
                                              [UIImage imageNamed:@"bg_pb_3@2x.png"],
                                              [UIImage imageNamed:@"bg_pb_4@2x.png"],
                                              [UIImage imageNamed:@"bg_pb_5@2x.png"],
                                              [UIImage imageNamed:@"bg_pb_6@2x.png"],
                                              nil];
      progressBarImageView.animationDuration = 2;
  progressBarImageView.animationRepeatCount = 999;
      [progressBarImageView startAnimating];
 progressBarImageView.hidden = NO;

  }
}

- (void)imageLoaderDidLoad:(NSNotification*)notification {
  [super imageLoaderDidLoad:notification];
  
    [progressBarImageView stopAnimating];
    progressBarImageView.hidden = YES;
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
  [super imageLoaderDidFailToLoad:notification];
  [progressBarImageView stopAnimating];
    progressBarImageView.hidden = YES;
}

@end
