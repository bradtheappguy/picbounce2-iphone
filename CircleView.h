//
//  CircleView.h
//  PicBounce2
//
//  Created by Brad Smith on 26/08/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView 
{CGFloat _progess;}
-(void) setProgress:(CGFloat)progress;
@property (nonatomic, readwrite) CGFloat progress;
@end
