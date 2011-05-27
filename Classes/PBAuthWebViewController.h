//
//  PBAuthWebViewController.h
//  PicBounce2
//
//  Created by Brad Smith on 5/19/11.
//  Copyright 2011 Clixtr, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface PBAuthWebViewController : UIViewController <UIWebViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, retain) NSString *authenticationURLString;

@end
