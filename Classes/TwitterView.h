//
//  TwitterView.h
//  PicBounce2
//
//  Created by Sunil on 4/29/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"



@interface TwitterView : UIViewController<UIWebViewDelegate> {
    UIWebView *TwitWeb;
     
    
    NSString *urladdress;
    
        
    MBProgressHUD *progressbar;

    
}

@property(nonatomic,retain) UIWebView *TwitWeb;


@end
