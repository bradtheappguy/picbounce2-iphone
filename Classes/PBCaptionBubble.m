//
//  PBCaptionBubble.m
//  PicBounce2
//
//  Created by Brad Smith on 11/9/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBCaptionBubble.h"

static NSString *kCaptionFontName = @"HelveticaNeue";
static CGFloat kCaptionFontSize = 12.0;
static CGFloat kVerticalPadding = 5;


@implementation PBCaptionBubble


@synthesize captionLabel = _captionLabel;
@synthesize bubbleView = _bubbleView;

+(UIFont *)captionfont {
  return [UIFont fontWithName:kCaptionFontName size:kCaptionFontSize];
}


+(CGSize) sizeForCaptionWithString:(NSString*)string {
  CGSize size = [string sizeWithFont:[PBCaptionBubble captionfont] constrainedToSize:CGSizeMake(255, 1000) lineBreakMode:UILineBreakModeWordWrap]; 
  return CGSizeMake(300, size.height+47);
}


-(void) awakeFromNib {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 47)];
   self.captionLabel = label;
  [label release];
   self.captionLabel.numberOfLines = 0;
  self.captionLabel.backgroundColor = [UIColor clearColor];
  self.captionLabel.font = [PBCaptionBubble captionfont];
  self.captionLabel.textColor = [UIColor colorWithRedInt:107 greenInt:107 blueInt:107 alphaInt:255];
  self.captionLabel.lineBreakMode = UILineBreakModeWordWrap;
  
  UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 47)];
  self.bubbleView = iv;
  [iv release];
  
  self.bubbleView.image = [[UIImage imageNamed:@"bg_caption_text"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
  
  [self addSubview:self.bubbleView];
  [self addSubview:self.captionLabel];
  self.hidden = YES;
  
}

- (void) dealloc {
  [_bubbleView release];
  [_captionLabel release];
  [super dealloc];
}

-(void) setText:(NSString *) text {
  if ([text length] > 0) {
    self.hidden = NO;
  }
  [self.captionLabel setText:text];
}

-(void) setFrame:(CGRect)frame {
  [super setFrame:frame];
  
  
  self.bubbleView.frame = CGRectMake(0, 0, 300, self.bounds.size.height-5);
  
  CGSize size = [self.captionLabel.text sizeWithFont:[PBCaptionBubble captionfont] constrainedToSize:CGSizeMake(255, 1000) lineBreakMode:UILineBreakModeWordWrap]; 

  self.captionLabel.frame = CGRectMake((300-255)/2, (frame.size.height/2)-(size.height/2) + 2, 255, size.height);
  
}


@end
