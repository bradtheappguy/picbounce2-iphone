//
//  TwitterButton.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "TwitterButton.h"

@implementation TwitterButton
@synthesize selected;
@synthesize label;

- (id)initWithPosition:(CGPoint)position {
	CGRect frame = CGRectMake(position.x, position.y, 54, 25);
    if ((self = [super initWithFrame:frame])) {
            // Initialization code
		[self setBackgroundImage:[[UIImage imageNamed:@"check_no.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_twitter_s.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
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
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_twitter_s.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"check_no.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
		
        }
	else {
		[self setBackgroundImage:[[UIImage imageNamed:@"check_no.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
		[self setBackgroundImage:[[UIImage imageNamed:@"btn_twitter_s.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
		
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
