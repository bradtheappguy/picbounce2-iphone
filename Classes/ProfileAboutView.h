//
//  ProfileAboutView.h
//  PicBounce2
//
//  Created by Nitin on 4/19/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileAboutView : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    NSArray *array4;
    NSArray *array5;
    
    UITableView *aboutTable;
    
}


-(void)Done;
@end
