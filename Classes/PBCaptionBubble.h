//
//  PBCaptionBubble.h
//  PicBounce2
//
//  Created by Brad Smith on 11/9/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBCaptionBubble : UIView {
  
}

@property (nonatomic, retain) UILabel *captionLabel;
@property (nonatomic, retain) UIImageView *bubbleView;

+(CGSize) sizeForCaptionWithString:(NSString*)string;
@end
