//
//  AccountSettingView.h
//  PicBounce2
//
//  Created by Nitin on 4/20/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"


@interface AccountSettingView : UIViewController

<UITableViewDataSource,UITableViewDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate> {
    
    NSArray *array6;
    
    UITableView *accountTable;
   
    UIView *fbview;
    UIButton *fbbutton;
   
    IBOutlet UILabel* _label;
    
    Facebook *facebook;
    
    
    IBOutlet UIButton* _getUserInfoButton;
    IBOutlet UIButton* _getPublicInfoButton;
    IBOutlet UIButton* _publishButton;
    IBOutlet UIButton* _uploadPhotoButton;
    
    NSArray* _permissions;
    
          
}

@property(readonly) Facebook *facebook;
@property(nonatomic,retain)UIButton *fbbutton;
@property(nonatomic, retain) UILabel* label;

-(IBAction)fbButtonClick:(id)sender;

-(IBAction)getUserInfo:(id)sender;

-(IBAction)getPublicInfo:(id)sender;

-(IBAction)publishStream:(id)sender;

-(IBAction)uploadPhoto:(id)sender;

-(void)Fbconnect;

@end
