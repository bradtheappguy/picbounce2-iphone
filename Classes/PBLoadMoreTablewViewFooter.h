//
//  PBLoadMoreTablewViewFooter.h
//  PicBounce2
//
//  Created by Brad Smith on 30/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBLoadMoreTablewViewFooter : UIView {
  UIActivityIndicatorView *loadingMoreActivityIndicatiorView;
  UIImageView *footerDecoration;
  
}
-(void) startLoadingAnimation;
-(void) stopLoadingAnimation;
-(void) setBottomReachedIndicatorHidden:(BOOL)hidden;
@end
