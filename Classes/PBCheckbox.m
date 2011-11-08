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

- (id)initWithPosition:(CGPoint)position withFontName:(NSString *)fontName withFontSize:(NSInteger)size {
	CGRect frame = CGRectMake(260, position.y+5, 20, 20);
  if ((self = [super initWithFrame:frame])) {
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
		
		self.label = [[UILabel alloc] initWithFrame:CGRectMake(-160, 0.0, 150, 28.0)];
    self.label.font = [UIFont fontWithName:fontName size:size];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
		self.selected = NO;
		
    [self addSubview:self.label];
  }
  return self;
}



-(void)touched:(id)sender {
  BOOL selected = self.selected;
	self.selected = !self.selected;
}

-(void)setSelected:(BOOL)isSelected {
	[super setSelected:isSelected];
	if (isSelected) {
		[self setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_on@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_off.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];		
	}
	else {
		[self setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_off.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"bg_sharingCheckbox_on@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
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
