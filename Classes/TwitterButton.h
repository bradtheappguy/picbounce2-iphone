//
//  TwitterButton.h
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterButton : UIButton {
	BOOL selected;
	UILabel *label;
}

@property (nonatomic) BOOL selected;
@property (nonatomic, retain) UILabel *label;
- (void) setText:(NSString *)text;
- (id)initWithPosition:(CGPoint)position;
@end
