//
//  ProfileSettingView.h
//  PicBounce2
//
//  Created by Nitin on 4/19/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileSettingView : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    NSArray *array1;
    NSArray *array2;
    NSArray *array3;
    UITableView *mytable;
    UISwitch *toggle;
    
    UINavigationController *navigation;
}

@property(nonatomic,retain)UISwitch *toggle;

-(void)back;
-(void)about;

@end
