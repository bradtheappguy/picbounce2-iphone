//
//  AboutWebView.h
//  PicBounce2
//
//  Created by Nitin on 4/21/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface AboutWebView : UIViewController<UIWebViewDelegate> {
    
    UIWebView *PicBounceWeb;
   
       
    NSInteger link;  ///flag
    NSString *urlAddress;
    
    MBProgressHUD *progressbar;
}
@property(nonatomic,retain) UIWebView *PicBounceWeb;

@property(nonatomic,readwrite) NSInteger link;


@end
