//
//  PBCommentsButton.h
//  PicBounce2
//
//  Created by Brad Smith on 11/11/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface PBCommentsButton : UIButton {
  OHAttributedLabel *label;
}

-(void) setCommentCount:(NSUInteger)commentCount;

@end
