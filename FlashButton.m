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
#import <QuartzCore/QuartzCore.h>

#define padding 4



@implementation FlashButton

@synthesize expanded;



+ (FlashButton *)button
{
  FlashButton *button = [[self alloc] initWithFrame:CGRectZero];
  UIImage *i =  [[UIImage imageNamed:@"bg_flash"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
  [button setBackgroundImage:i forState:UIControlStateNormal];
  return [button autorelease];
}

-(UILabel *) labelWithText:(NSString *)text {
  UILabel *label = [[UILabel alloc] init];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
  label.text = text;
  //label.contentMode = UIViewContentModeLeft;
  label.backgroundColor = [UIColor clearColor];
  [label sizeToFit];
  return [label autorelease];
}


-(UIView *)viewWithLabel:(UIView *)label {
  UIView *view = [[UIView alloc] initWithFrame:label.bounds];
  [view addSubview:label];
  view.clipsToBounds = YES;
  UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
  [view addGestureRecognizer:tgr];
  [tgr release];
  return [view autorelease];
}


-(id) initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {    
    self.frame = CGRectMake(5, 5, 73, 36);
    self.adjustsImageWhenHighlighted = NO;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:tgr];
    [self addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    flashIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_flash"]];
    flashIcon.userInteractionEnabled = YES;
    flashIcon.center = CGPointMake(flashIcon.center.x+10, self.bounds.size.height/2);
    [self addSubview:flashIcon];
    [flashIcon addGestureRecognizer:tgr];
    [tgr release];
    
    autoLabel = [self labelWithText:@"Auto"];
    onLabel = [self labelWithText:@"On"];
    offLabel = [self labelWithText:@"Off"];
    
    autoView = [self viewWithLabel:autoLabel];
    onView = [self viewWithLabel:onLabel];
    offView = [self viewWithLabel:offLabel];

    torchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_torch"]];
    torchIcon.contentMode = UIViewContentModeCenter;
    torchIcon.backgroundColor = [UIColor clearColor];
    torchView = [self viewWithLabel:torchIcon];

    
    autoView.backgroundColor = [UIColor clearColor];
    onView.layer.borderColor = [UIColor clearColor].CGColor;
    onView.layer.borderWidth = 1.0;
    
    offView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:autoView];
    [self addSubview:onView];
    [self addSubview:offView];
    [self addSubview:torchView];
    
    [self expand];
  }
  return self;
}

-(void) setWidth {
  CGFloat width = flashIcon.frame.origin.x + flashIcon.frame.size.width + onView.frame.size.width + offView.frame.size.width + torchView.frame.size.width + autoView.frame.size.width + 13;
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

-(void) setOn {
  torchView.frame = CGRectMake(torchView.frame.origin.x - onView.frame.size.width - autoView.frame.size.width, torchView.frame.origin.y, 0, torchView.frame.size.height);
  
  onView.frame = CGRectMake(onView.frame.origin.x - autoView.frame.size.width, autoView.frame.origin.y, onLabel.frame.size.width + padding, onView.frame.size.height);

  offView.frame = CGRectMake(offView.frame.origin.x- autoLabel.frame.size.width, offView.frame.origin.y, 0, offView.frame.size.height);
  autoView.frame = CGRectMake(autoView.frame.origin.x, autoView.frame.origin.y, 0, autoView.frame.size.height);
  [self setWidth];
}

-(void) setOff {
  torchView.frame = CGRectMake(torchView.frame.origin.x - onView.frame.size.width - autoView.frame.size.width, torchView.frame.origin.y, 0, torchView.frame.size.height);
  offView.frame = CGRectMake(offView.frame.origin.x- autoLabel.frame.size.width - onLabel.frame.size.width, offView.frame.origin.y, offLabel.frame.size.width + padding, offView.frame.size.height);
  
  onView.frame = CGRectMake(onView.frame.origin.x - autoView.frame.size.width, autoView.frame.origin.y, 0, onView.frame.size.height);
  
  autoView.frame = CGRectMake(autoView.frame.origin.x, autoView.frame.origin.y, 0, autoView.frame.size.height);
  [self setWidth];
}

-(void) setTorch {
  CGFloat x = torchView.frame.origin.x - onView.frame.size.width - autoView.frame.size.width - offView.frame.size.width;
  torchView.frame = CGRectMake(x, torchView.frame.origin.y, torchIcon.frame.size.width+padding, torchView.frame.size.height);
  
  offView.frame = CGRectMake(offView.frame.origin.x- autoLabel.frame.size.width - onLabel.frame.size.width, offView.frame.origin.y, 0, offView.frame.size.height);
  
  onView.frame = CGRectMake(onView.frame.origin.x - autoView.frame.size.width, autoView.frame.origin.y, 0, onView.frame.size.height);
  
  autoView.frame = CGRectMake(autoView.frame.origin.x, autoView.frame.origin.y, 0, autoView.frame.size.height);
  [self setWidth];
}


-(void) setAuto {
  torchView.frame = CGRectMake(torchView.frame.origin.x - onView.frame.size.width - offView.frame.size.width, torchView.frame.origin.y, 0, torchView.frame.size.height);
  
  offView.frame = CGRectMake(offView.frame.origin.x- onLabel.frame.size.width, offView.frame.origin.y, 0, autoView.frame.size.height);
  onView.frame = CGRectMake(onView.frame.origin.x, onView.frame.origin.y, 0, autoView.frame.size.height);
  
  [self setWidth];
  
}

-(void) expand {
  //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 200, self.frame.size.height);
  

  
  autoView.frame = CGRectMake(flashIcon.frame.origin.x+flashIcon.frame.size.width, 
                              4, 
                              autoLabel.frame.size.width + padding, 
                              31); 
  
  onView.frame = CGRectMake(autoView.frame.origin.x + autoView.frame.size.width, 
                            autoView.frame.origin.y, 
                            onLabel.frame.size.width + padding, 
                            autoView.frame.size.height);
  offView.frame  = CGRectMake(autoView.frame.origin.x + autoView.frame.size.width + onView.frame.size.width, 
                              autoView.frame.origin.y, offLabel.frame.size.width + padding, 
                              autoView.frame.size.height);
  
  torchView.backgroundColor = [UIColor clearColor];
  
  torchView.frame = CGRectMake(autoView.frame.origin.x + autoView.frame.size.width + onView.frame.size.width + offView.frame.size.width + padding, 
                               autoView.frame.origin.y, 
                               torchIcon.frame.size.width, 
                               autoView.frame.size.height);
  
  autoLabel.center = CGPointMake(autoView.bounds.size.width/2, autoView.bounds.size.height/2);
  offLabel.center = CGPointMake(offView.bounds.size.width/2, autoView.bounds.size.height/2);
  onLabel.center = CGPointMake(onView.bounds.size.width/2, autoView.bounds.size.height/2);
  torchIcon.center = CGPointMake(torchIcon.bounds.size.width/2, autoView.bounds.size.height/2); 
  [self setWidth];
}


- (void) viewTapped:(UITapGestureRecognizer *)sender {
  [UIView beginAnimations:@"" context:nil];
  [UIView setAnimationDuration:0.33];
  
  if (self.expanded) {
    UIView *sendingView = nil;
    if ([sender respondsToSelector:@selector(view)]) {
      sendingView = [sender view];
    }
    
    if (sendingView == autoView) {
      [self setAuto];
    }
    if (sendingView == onView) {
      [self setOn];
    }
    if (sendingView == offView) {
      [self setOff];
    }
    if (sendingView == torchView) {
      [self setTorch];
    }
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
