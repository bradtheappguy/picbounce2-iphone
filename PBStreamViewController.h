//
//  PBProfileViewController.h
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PBProfileHeaderView.h"
#import "PBLoginViewController.h"
#import "PBRootViewController.h"
#import "EGOImageView.h"
#import "PBLoadMoreTablewViewFooter.h"
#import "PBEmptyView.h"

@class PBPhotoHeaderView, PBTableTitleTableViewCell, PBPhotoCell;

@interface PBStreamViewController : PBRootViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
  IBOutlet UISegmentedControl *segmentedControl;
  
  IBOutlet PBPhotoHeaderView *photoHeader;
  IBOutlet PBTableTitleTableViewCell *tableTitleTableViewCell;
  
  
  IBOutlet PBPhotoCell *cell;
  
  BOOL shouldShowProfileHeader;
  BOOL shouldShowProfileHeaderBeforeNetworkLoad;
  
  
  NSURL *preloadedAvatarURL;
  NSString *preloadedLocation;
  NSString *preloadedName;
  
  UIButton *setting;  
  
  UITextView *commentTextField;
  
  UIButton *activeLeaveCommentButton;
  
  UIImageView *profileAvatarImageView;
  UINavigationBar *customNavigationBar;
  PBLoadMoreTablewViewFooter *footerView;
    
    
}

@property (nonatomic, retain) IBOutlet PBEmptyView *emptyView;
@property (nonatomic, retain) IBOutlet PBProfileHeaderView *profileHeader;
@property (nonatomic, retain) IBOutlet EGOImageView *avatarIcon;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *photosCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *followersCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *followingCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *badgesCountLabel;






@property (nonatomic, retain) IBOutlet NSURL *preloadedAvatarURL;
@property (nonatomic, retain) IBOutlet NSString *preloadedLocation;
@property (nonatomic, retain) IBOutlet NSString *preloadedName;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic,retain)IBOutlet UIButton *setting; 

@property (readwrite) BOOL shouldShowProfileHeader;
@property (readwrite) BOOL shouldShowProfileHeaderBeforeNetworkLoad;
@property (readwrite) BOOL shouldShowUplodingItems;


//-(IBAction) followButtonPressed:(id) sender;

-(IBAction) loginButtonPressed:(id)sender;
-(IBAction) photosButtonPressed;
-(IBAction) followersButtonPressed;
-(IBAction) badgesButtonPressed;
-(IBAction) taggedPeopleButtonPressed:(id)sender;
-(BOOL) moreDataAvailable;
-(void) configureNavigationBar;
- (UIView *) footerViewForTable:(UITableView *)tableView;
@end
