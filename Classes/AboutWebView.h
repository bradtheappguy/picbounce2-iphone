//
//  AboutWebView.h
//  PicBounce2
//
//  Created by Nitin on 4/21/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutWebView : UIViewController<UIWebViewDelegate> {
    
    UIWebView *PicBounceWeb;
   
    UIView *indicatorView;
	UIActivityIndicatorView *scrollingWheel;
   
    NSInteger link;  ///flag
    NSString *urlAddress;
    
}
@property(nonatomic,retain) UIWebView *PicBounceWeb;
@property(nonatomic,retain)UIActivityIndicatorView *scrollingWheel;
@property(nonatomic,readwrite) NSInteger link;


@end
