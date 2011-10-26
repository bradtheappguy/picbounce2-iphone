//
//  Checkbox.m
//  BBE
//
//  Created by Avnish Chuchra on 4/22/11.
//  Copyright 2010 GraveYard. All rights reserved.
//

#import "Checkbox.h"


@implementation Checkbox
@synthesize selected;
@synthesize label;

- (id)initWithPosition:(CGPoint)position {
	CGRect frame = CGRectMake(270, position.y, 24, 27);
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_n@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_s@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
		[self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
		selected = NO;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(-100, 0.0, 150, 28.0)];
        label.font = [UIFont systemFontOfSize:13];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor];
		[self addSubview:label];
    }
    return self;
}



-(void)touched:(id)sender
{
	selected = !selected;
	[self setSelected:selected];
}

-(void)setSelected:(BOOL)isSelected
{
	selected = isSelected;
	if (selected)
	{
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_s@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_n@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
		
	}
	else {
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_n@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_check_s@2x.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
		
	}
}

-(void)setText:(NSString *)text
{
	label.text = text;
}


- (void)dealloc {
	[label release];
    [super dealloc];
}


@end
