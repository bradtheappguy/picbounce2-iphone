//
//  ProfileAboutView.h
//  PicBounce2
//
//  Created by Nitin on 4/19/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface ProfileAboutView : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate> {
    
    NSArray *array4;
    NSArray *array5;
    UITableView *aboutTable;
    
}


-(void)Done;


@end
