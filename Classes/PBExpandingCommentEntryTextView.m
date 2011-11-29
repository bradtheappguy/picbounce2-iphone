//
//  MyView.m
//  test22
//
//  Created by BradSmith on 3/26/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBExpandingCommentEntryTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "HPTextViewInternal.h"
@implementation PBExpandingCommentEntryTextView

@synthesize scrollView;
@synthesize commentTextView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
    
- (void) awakeFromNib {
  numberOfLines = 1;
  UIImage * bgImage = [[UIImage imageNamed:@"bg_commentBar.png"] stretchableImageWithLeftCapWidth:200 topCapHeight:22];
  self.image = bgImage;
  [self setContentMode:UIViewContentModeScaleToFill];
  self.clipsToBounds = YES;
  self.userInteractionEnabled = YES;
 
  
  textViewClipp = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 300, 26)];
  textViewClipp.backgroundColor = [UIColor clearColor];
  textViewClipp.alpha = 1;
  
  [self addSubview:textViewClipp];
  
  commentTextView = [[HPTextViewInternal alloc] initWithFrame:CGRectMake(0, -4, 300, 36)];
  commentTextView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
  commentTextView.font = [UIFont systemFontOfSize:16];
    commentTextView.returnKeyType = UIReturnKeySend;
  commentTextView.scrollIndicatorInsets = UIEdgeInsetsMake(3, 0, 5, 0);
  commentTextView.backgroundColor = [UIColor clearColor];
  commentTextView.delegate = self;
  commentTextView.alpha = 1;
  textHeight = commentTextView.contentSize.height;
      commentTextView.scrollEnabled = NO;
  [textViewClipp addSubview:commentTextView];
    
    //add the avatar
    
//    UIView *avatar = [[UIView alloc] initWithFrame:CGRectMake(6, 5, 30, 30)];
//    avatar.backgroundColor = [UIColor blueColor];
//    [self addSubview:avatar];
//  [avatar release];
}

- (void) grow {
  
}




-(IBAction) press {
  numberOfLines++;
  [self grow];
}

- (void)textViewDidChange:(UITextView *)aTtextView
{
  CGFloat height = commentTextView.contentSize.height;
  if ([commentTextView.text length] < 2) {
    height = 36;
      
  }
  if (commentTextView.contentSize.height < 36) {
    height = 36;
  }
  if (commentTextView.contentSize.height > 36) {
    textViewClipp.clipsToBounds = YES;
  }
  else {
    textViewClipp.clipsToBounds = NO;
  }
  
  if (commentTextView.contentSize.height >= 100) {
    height = 100;
    commentTextView.scrollEnabled = YES;
  }
  else {
    commentTextView.scrollEnabled = NO;
  }
  if (height != textHeight) {
    CGFloat diff = textHeight - height;
    textHeight = height;

    [UIView beginAnimations:@"" context:nil];
    
    CGRect frame = self.frame;
    frame.origin.y += diff;
    frame.size.height -= diff;
    self.frame = frame;
    
    commentTextView.frame = CGRectMake(commentTextView.frame.origin.x, commentTextView.frame.origin.y, commentTextView.frame.size.width, commentTextView.frame.size.height - diff);
    
    textViewClipp.frame = CGRectMake(textViewClipp.frame.origin.x, textViewClipp.frame.origin.y, textViewClipp.frame.size.width, textViewClipp.frame.size.height - diff);
    
    [commentTextView scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, scrollView.contentInset.bottom - diff, 0);
    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, scrollView.scrollIndicatorInsets.bottom - diff, 0);
    [UIView commitAnimations]; 
  }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {  
    BOOL shouldChangeText = YES;  
    
    if ([text isEqualToString:@"\n"]) {  
            // Find the next entry field  
        
            
        [commentTextView resignFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PostComment" object:nil userInfo:nil];
        shouldChangeText = NO;  
    }  
    return shouldChangeText;  
}
/*
 
 1  100         40
 2  100-40      80
 3  100-80     120
 4  100-120    160
 
 */
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
	// Start with a background whose color we don't use in the demo
	CGContextSetGrayFillColor(context, 0.2, 1.0);
	CGContextFillRect(context, self.bounds);
	CGContextSetBlendMode(context, kCGBlendModeCopy);

  
  
  CGGradientRef glossGradient;
  CGColorSpaceRef rgbColorspace;
  size_t num_locations = 2;
  CGFloat locations[2] = { 0.0,          //top
                          1.0 };         //bottom
  
  CGFloat components[8] = { 1.0, 1.0, 1.0, 1.0,  // Start color
                            219/255, 220/255, 233/255, 1.0 }; // End color
  
  rgbColorspace = CGColorSpaceCreateDeviceRGB();
  glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
  
  CGRect currentBounds = self.bounds;
  CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
  CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
  CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
  
  CGGradientRelease(glossGradient);
  CGColorSpaceRelease(rgbColorspace);
  
  
}*/


- (void)dealloc
{
    [super dealloc];
    [commentTextView release];
}

@end
