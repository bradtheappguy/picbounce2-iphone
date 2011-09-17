//
//  PBProfileViewController.h
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#import "PBRootViewController.h"
#import "EGOImageView.h"
#import "PBProfileHeaderView.h"

@class PBPhotoHeaderView, PBTableTitleTableViewCell, PBPhotoCell;

@interface PBStreamViewController : PBRootViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
  IBOutlet UISegmentedControl *segmentedControl;

  IBOutlet PBPhotoHeaderView *photoHeader;
  IBOutlet PBTableTitleTableViewCell *tableTitleTableViewCell;
  
  
  IBOutlet PBPhotoCell *cell;
  
  BOOL shouldShowProfileHeader;
  BOOL shouldShowProfileHeaderBeforeNetworkLoad;
  BOOL shouldShowFollowingBar;
  
  UIActivityIndicatorView *loadingMoreActivityIndicatiorView;
  UIImageView *footerDecoration;
  
  IBOutlet NSURL *preloadedAvatarURL;
  IBOutlet NSString *preloadedLocation;
  IBOutlet NSString *preloadedName;
  
   IBOutlet UIButton *setting;  
  
  UITextView *commentTextField;
  
  UIButton *activeLeaveCommentButton;
  
  UIImageView *profileAvatarImageView;
  
}

@property (nonatomic, retain) IBOutlet PBProfileHeaderView *profileHeader;
@property (nonatomic, retain) IBOutlet UIView *profileHeaderWithFollowBar;
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
@property (readwrite) BOOL shouldShowFollowingBar;
@property (readwrite) BOOL shouldShowUplodingItems;


//-(IBAction) followButtonPressed:(id) sender;
-(IBAction) bounceButtonPressed:(id) sender;

-(IBAction) photosButtonPressed;
-(IBAction) followingButtonPressed;
-(IBAction) followersButtonPressed;
-(IBAction) badgesButtonPressed;
-(IBAction) taggedPeopleButtonPressed:(id)sender;


- (UIView *) footerViewForTable:(UITableView *)tableView;
@end
