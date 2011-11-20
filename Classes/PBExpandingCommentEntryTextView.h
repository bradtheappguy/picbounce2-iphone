//
//  MyView.h
//  test22
//
//  Created by BradSmith on 3/26/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBExpandingCommentEntryTextView : UIImageView <UITextViewDelegate>{
  NSUInteger numberOfLines;
  
  
  CGFloat textHeight;
  UIView *textViewClipp;
  
  UIScrollView *scrollView;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITextView *commentTextView;
@end
