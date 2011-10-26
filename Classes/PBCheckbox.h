//
//  Checkbox.h
//   BBE
//
//  Created by Avnish Chuchra on 4/22/11.
//  Copyright 2010 GraveYard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBCheckbox : UIButton {

}

@property (nonatomic, readwrite) BOOL selected;
@property (nonatomic, retain) UILabel *label;

- (void) setText:(NSString *)text;
- (id)initWithPosition:(CGPoint)position;

@end
