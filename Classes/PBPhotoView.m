//
//  PBPhotoView.m
//  PicBounce2
//
//  Created by Brad Smith on 22/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBPhotoView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+PBColor.h"

@implementation PBPhotoView

static CGFloat kProgressBarWidth = 180.0f;
static CGFloat kProgressBarHeight = 180.0f;


-(void) awakeFromNib {
  self.backgroundColor = [UIColor PBPhotoViewBackgroundColor];
    progressBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kProgressBarWidth, kProgressBarHeight)];
    progressBarImageView.center = self.center;
    [self addSubview:progressBarImageView];
    [self bringSubviewToFront:progressBarImageView];
    progressBarImageView.hidden = YES;
  progressBarImageView.backgroundColor = [UIColor clearColor];
    progressBarImageView.image = [UIImage imageNamed:@"bg_pb@2x.png"];
  self.layer.borderColor = [UIColor PBPhotoViewBorderColor].CGColor;
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
      progressBarImageView.animationDuration = 4;
    progressBarImageView.animationRepeatCount = 1;

      [progressBarImageView startAnimating];
    progressBarImageView.image = [UIImage imageNamed:@"bg_pb_6@2x.png"];
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

-(void) layoutSubviews {
  progressBarImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

@end
