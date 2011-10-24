//
//  MyView.h
//  test22
//
//  Created by BradSmith on 3/26/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyView : UIImageView <UITextViewDelegate>{
  NSUInteger numberOfLines;
  
  UITextView *a_CommentTextView;
  
  CGFloat textHeight;
  UIView *textViewClipp;
  
  UIScrollView *scrollView;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITextView *a_CommentTextView;
@end
