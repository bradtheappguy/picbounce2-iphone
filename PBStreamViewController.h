//
//  PBProfileViewController.h
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PBRootViewController.h"
#import "PBProfileHeaderCell.h"
#import "PBHeaderTableViewCell.h"
#import "PBPhotoCell.h"
#import "PBPersonListViewController.h"
#import "PBBadgeCollectionViewController.h"
#import "PBTableTitleTableViewCell.h"

@interface PBStreamViewController : PBRootViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
  IBOutlet UISegmentedControl *segmentedControl;
  
  IBOutlet PBProfileHeaderCell *headerCell;
  IBOutlet PBHeaderTableViewCell *headerTableViewCell;
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
  
  UITextView *commentTextField;
  
  UIButton *activeLeaveCommentButton;
  
  UIImageView *profileAvatarImageView;
}

@property (nonatomic, retain) IBOutlet NSURL *preloadedAvatarURL;
@property (nonatomic, retain) IBOutlet NSString *preloadedLocation;
@property (nonatomic, retain) IBOutlet NSString *preloadedName;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property (readwrite) BOOL shouldShowProfileHeader;
@property (readwrite) BOOL shouldShowProfileHeaderBeforeNetworkLoad;
@property (readwrite) BOOL shouldShowFollowingBar;

-(IBAction) followButtonPressed:(id) sender;
-(IBAction) bounceButtonPressed:(id) sender;
-(IBAction) leaveCommentButtonPressed:(id) sender;

-(IBAction) photosButtonPressed;
-(IBAction) followingButtonPressed;
-(IBAction) followersButtonPressed;
-(IBAction) badgesButtonPressed;
-(IBAction) Dosettings:(id)sender;

- (UIImageView *) headerForAboveTableView:(UITableView *)tableView;
- (UIImageView *) footerForBelowTableView:(UITableView *)tableView;
- (UIView *) footerViewForTable:(UITableView *)tableView;
@end
