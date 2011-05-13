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
    
    NSArray *serviceNames;
    
    UITableView *accountTable;
   
    
    UIButton *fbbutton;
    UIButton *twbutton;
    UIButton *flkrbutton;
    UIButton *tmblrbutton;
    UIButton *pstrsbutton;
    UIButton *myspacebutton;
   
    IBOutlet UILabel* _label;
    
    Facebook *_facebook;
    
    IBOutlet UIButton* _getUserInfoButton;
    IBOutlet UIButton* _getPublicInfoButton;
    IBOutlet UIButton* _publishButton;
    IBOutlet UIButton* _uploadPhotoButton;
    
    NSArray *_permissions;
}

@property(readonly) Facebook *facebook;
@property(nonatomic,retain)UIButton *fbbutton;
@property(nonatomic, retain) UILabel* label;
@property(nonatomic,retain)UIButton *twbutton;
@property(nonatomic,retain)UIButton *flkrbutton;
@property(nonatomic,retain)UIButton *tmblrbutton;
@property(nonatomic,retain)UIButton *pstrsbutton;
@property(nonatomic,retain)UIButton *myspacebutton;

- (void)login;
- (void)logout;
- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate;
-(void)twitterLogin;
@end
