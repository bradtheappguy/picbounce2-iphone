//
//  Checkbox.m
//  BBE
//
//  Created by Avnish Chuchra on 4/22/11.
//  Copyright 2010 GraveYard. All rights reserved.
//

#import "PBCheckbox.h"

@implementation PBCheckbox

@synthesize selected = _selected;
@synthesize label = _label;

- (id)initWithPosition:(CGPoint)position {
	CGRect frame = CGRectMake(260, position.y, 24, 27);
  if ((self = [super initWithFrame:frame])) {
    // Initialization code
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_n@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
		[self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
		self.selected = NO;
		
		self.label = [[UILabel alloc] initWithFrame:CGRectMake(-140, 0.0, 150, 28.0)];
    self.label.font = [UIFont systemFontOfSize:15];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.textColor = [UIColor lightGrayColor];
		[self addSubview:self.label];
  }
  return self;
}



-(void)touched:(id)sender {
	self.selected = !self.selected;
	[self setSelected:self.selected];
}

-(void)setSelected:(BOOL)isSelected {
	_selected = isSelected;
	if (self.selected) {
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_n@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];		
	}
	else {
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_n@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
	}
}

-(void)setText:(NSString *)text {
	self.label.text = text;
}


- (void)dealloc {
	[_label release];
  [super dealloc];
}


@end
