//
//  PBLoadMoreTablewViewFooter.m
//  PicBounce2
//
//  Created by Brad Smith on 30/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBLoadMoreTablewViewFooter.h"

@implementation PBLoadMoreTablewViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      self.backgroundColor = [UIColor clearColor];
      loadingMoreActivityIndicatiorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      loadingMoreActivityIndicatiorView.frame = CGRectMake(0, 0, 20, 20);
      loadingMoreActivityIndicatiorView.hidesWhenStopped = YES;
      [loadingMoreActivityIndicatiorView stopAnimating];
      footerDecoration = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hr_end.png"]] autorelease]; 
      footerDecoration.hidden = YES;
      footerDecoration.contentMode = UIViewContentModeCenter;
      footerDecoration.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
      loadingMoreActivityIndicatiorView.center = CGPointMake( self.center.x , 35);
      [self addSubview:footerDecoration];
      [self addSubview:loadingMoreActivityIndicatiorView];
    }
    return self;
}


-(void) startLoadingAnimation{
  [loadingMoreActivityIndicatiorView startAnimating];
}
-(void) stopLoadingAnimation {
  [loadingMoreActivityIndicatiorView stopAnimating];
  
}
-(void) setBottomReachedIndicatorHidden:(BOOL)hidden {
  [footerDecoration setHidden:hidden];
}



@end
