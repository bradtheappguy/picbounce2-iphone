//
//  FlashButton.m
//  PicBounce2
//
//  Created by Brad Smith on 7/12/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//


// Helvetica 28 pt bold
// Pure black @ 65%

#import "FlashButton.h"

@implementation FlashButton

@synthesize expanded;



+ (FlashButton *)button
{
  FlashButton *button = [[self alloc] initWithFrame:CGRectZero];
  UIImage *i =  [[UIImage imageNamed:@"btn_flash_n"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
  [button setBackgroundImage:i forState:UIControlStateNormal];
  [button addTarget:button action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
  

  return [button autorelease];
}

-(UILabel *) labelWithText:(NSString *)text {
  UILabel *label = [[UILabel alloc] init];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
  label.text = text;
  label.contentMode = UIViewContentModeLeft;
  label.backgroundColor = [UIColor clearColor];
  [label sizeToFit];
  return [label autorelease];
}

-(id) initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.frame = CGRectMake(5, 5, 73, 37);
    self.adjustsImageWhenHighlighted = NO;
    autoLabel = [self labelWithText:@"Auto"];
    onLabel = [self labelWithText:@"On"];
    offLabel = [self labelWithText:@"Off"];
    
    autoView = [[UIView alloc] initWithFrame:autoLabel.bounds];
    [autoView addSubview:autoLabel];
    autoView.clipsToBounds = YES;
    onView = [[UIView alloc] initWithFrame:onLabel.bounds];
    [onView addSubview:onLabel];
    onView.clipsToBounds = YES;
    offView = [[UIView alloc] initWithFrame:offLabel.bounds];
    offView.clipsToBounds = YES;
    [offView addSubview:offLabel];
    autoView.backgroundColor = [UIColor redColor];
    onView.backgroundColor = [UIColor blueColor];
    offView.backgroundColor = [UIColor greenColor];
    
    [self addSubview:autoView];
    [self addSubview:onView];
    [self addSubview:offView];
    
    [self expand];
  }
  return self;
}

-(void) setOn {
  onView.frame = CGRectMake(onView.frame.origin.x - autoView.frame.size.width, autoView.frame.origin.y, onLabel.frame.size.width, onLabel.frame.size.height);

  offView.frame = CGRectMake(offView.frame.origin.x- autoLabel.frame.size.width, offView.frame.origin.y, 0, offLabel.frame.size.height);
  autoView.frame = CGRectMake(autoView.frame.origin.x, autoView.frame.origin.y, 0, autoLabel.frame.size.height);
}

-(void) setOff {
  offView.frame = CGRectMake(offView.frame.origin.x- autoLabel.frame.size.width - onLabel.frame.size.width, offView.frame.origin.y, offLabel.frame.size.width, offLabel.frame.size.height);
  
  onView.frame = CGRectMake(onView.frame.origin.x - autoView.frame.size.width, autoView.frame.origin.y, onLabel.frame.size.width, onLabel.frame.size.height);
  
  autoView.frame = CGRectMake(autoView.frame.origin.x, autoView.frame.origin.y, 0, autoLabel.frame.size.height);
}

-(void) setAuto {
  offView.frame = CGRectMake(offView.frame.origin.x- onLabel.frame.size.width, offView.frame.origin.y, 0, offLabel.frame.size.height);
  onView.frame = CGRectMake(onView.frame.origin.x, onView.frame.origin.y, 0, onLabel.frame.size.height);
}

-(void) expand {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 200, self.frame.size.height);
  autoView.frame = CGRectMake(26, 5, autoLabel.frame.size.width, 30); 
  
  onView.frame = CGRectMake(autoView.frame.origin.x + autoView.frame.size.width, autoView.frame.origin.y, onLabel.frame.size.width, onLabel.frame.size.height);
  offView.frame  = CGRectMake(autoView.frame.origin.x + autoView.frame.size.width + onView.frame.size.width, autoView.frame.origin.y, offLabel.frame.size.width, offLabel.frame.size.height);
}


- (void) buttonTapped:(id)sender {
  [UIView beginAnimations:@"" context:nil];
  [UIView setAnimationDuration:2];
  
  if (self.expanded) {
    [self setOff];
  }
  else {
    [self expand];
  }
  [UIView commitAnimations];
  self.expanded = !self.expanded;
}




-(void) layoutSubviews {
  [super layoutSubviews];
}

@end
