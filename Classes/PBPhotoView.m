//
//  PBPhotoView.m
//  PicBounce2
//
//  Created by Brad Smith on 22/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBPhotoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PBPhotoView

-(void) awakeFromNib {
  self.backgroundColor = [UIColor colorWithRed:241/255.0 green:233/255.0 blue:227/255.0 alpha:1];
    progressBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 180, 17)];
    progressBarImageView.center = self.center;
    [self addSubview:progressBarImageView];
    [self bringSubviewToFront:progressBarImageView];
    progressBarImageView.hidden = YES;
  progressBarImageView.backgroundColor = [UIColor clearColor];
    progressBarImageView.image = [UIImage imageNamed:@"bg_pb@2x.png"];
  self.layer.borderColor = [UIColor colorWithRed:169/255.0 green:164/255.0 blue:154/255.0 alpha:1].CGColor;
  self.layer.borderWidth = 1;
    
    
    
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
    progressBarImageView.animationRepeatCount = 1;

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
