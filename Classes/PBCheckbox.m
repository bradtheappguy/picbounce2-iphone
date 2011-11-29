//
//  Checkbox.m
//  BBE
//
//  Created by Avnish Chuchra on 4/22/11.
//  Copyright 2010 GraveYard. All rights reserved.
//

#import "PBCheckbox.h"

@implementation PBCheckbox

@synthesize label = _label;
@synthesize selected = _selected;

- (id)initWithPosition:(CGPoint)position withFontName:(NSString *)fontName withFontSize:(NSInteger)size {
	CGRect frame = CGRectMake(260, position.y+5, 20, 20);
  if ((self = [super initWithFrame:frame])) {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 20, 20);
    _button.backgroundColor = [UIColor clearColor];
    [_button addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-160, 0.0, 150, 28.0)];
    self.label = label;
    [label release];

    self.label.font = [UIFont fontWithName:fontName size:size];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
		_button.selected = NO;
		
    [self addSubview:self.label];
    [self addSubview:_button];
    
  }
  return self;
}



-(void)touched:(id)sender {
	[self setSelected:!self.selected];
}

-(void)setSelected:(BOOL)isSelected {
  _selected = isSelected;
	[_button setSelected:isSelected];
	if (isSelected) {
		[_button setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_on.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[_button setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_off.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];		
	}
	else {
		[_button setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_off.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[_button setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_on.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
	}
}

-(void)setText:(NSString *)text {
	self.label.text = text;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
  [_button addTarget:target action:action forControlEvents:controlEvents];
  _button.tag = self.tag;
}

- (void)dealloc {
	[_label release];
  [super dealloc];
}


@end
