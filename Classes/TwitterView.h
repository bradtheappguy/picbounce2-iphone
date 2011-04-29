//
//  TwitterView.h
//  PicBounce2
//
//  Created by Sunil on 4/29/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterView : UIViewController<UIWebViewDelegate> {
    
    UIWebView *TwitWeb;
     NSString *urladdress;
    
    UIView *indicatorView;
	UIActivityIndicatorView *scrollingWheel;
    

    
}

@property(nonatomic,retain) UIWebView *TwitWeb;
@property(nonatomic,retain)UIActivityIndicatorView *scrollingWheel;

@end
