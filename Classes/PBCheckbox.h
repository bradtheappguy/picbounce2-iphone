//
//  Checkbox.h
//   BBE
//
//  Created by Avnish Chuchra on 4/22/11.
//  Copyright 2010 GraveYard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBCheckbox : UIView {
  UIButton *_button;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, readwrite) BOOL selected;

- (void) setText:(NSString *)text;
- (id)initWithPosition:(CGPoint)position withFontName:(NSString *)fontName withFontSize:(NSInteger)size;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
