//
//  TwitterView.h
//  PicBounce2
//
//  Created by Sunil on 4/29/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBProgressHUD.h"



@interface PBTwitterViewController : UIViewController<UIWebViewDelegate> {
    UIWebView *TwitWeb;
     
    
    NSString *urladdress;
    
        
    PBProgressHUD *progressbar;

    
}

@property(nonatomic,retain) UIWebView *TwitWeb;
@property(nonatomic,retain) NSURL *authenticationURL;

@end
