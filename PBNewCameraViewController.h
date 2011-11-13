//
//  PBNewCameraViewController.h
//  test
//
//  Created by Brad Smith on 11/12/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBNewPostViewController.h"


@interface PBNewCameraViewController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
  UIView *toolBar;
}

@end
