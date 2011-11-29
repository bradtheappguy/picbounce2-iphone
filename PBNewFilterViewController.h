//
//  PBFilterViewController.h
//  PicBounce2
//
//  Created by Brad Smith on 11/12/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBFilterNotifierDelegate.h"

@class PBFilterManager;

@interface PBNewFilterViewController : UIViewController <PBFilterNotifierDelegate> {

  PBFilterManager *filterManager;
  UIImage *originalImage;
}

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIScrollView *filterScrollView;
@end
