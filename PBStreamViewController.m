//
//  PBProfileViewController.m
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//
    
#import "PBStreamViewController.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#define CELL_PADDING 15
#import "PBCommentListViewController.h"
#import "ProfileSettingView.h"
#import "PBLoginViewController.h"
#import "PathBoxesAppDelegate.h"
#import "ASIDownloadCache.h"
@implementation PBStreamViewController

@synthesize shouldShowProfileHeader;
@synthesize shouldShowProfileHeaderBeforeNetworkLoad;
@synthesize shouldShowFollowingBar;
@synthesize segmentedControl;

@synthesize preloadedAvatarURL;
@synthesize preloadedLocation;
@synthesize preloadedName;
@synthesize setting;


-(void)xxx {
    [self dismissModalViewControllerAnimated:YES];
    [self loadDataFromCacheIfAvailable];
}

-(void) configureNavigationBar {
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  [backButton release];
  
  //UIBarButtonItem *settings  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings",nil) style:UIBarButtonItemStyleBordered target:self //action:@selector(settingsButtonPressed:)];
  //self.navigationItem.rightBarButtonItem = settings;
 
  if ([(PathBoxesAppDelegate *)[[UIApplication sharedApplication] delegate] authToken]) {
    UIBarButtonItem *logoutButton  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    self.navigationItem.leftBarButtonItem = nil;
  }
  else {
    UIBarButtonItem *loginButton  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(loginButtonPressed:)];
    self.navigationItem.leftBarButtonItem = loginButton;
    self.navigationItem.rightBarButtonItem = nil;
  }

}

- (void) logoutButtonPressed:(id)sender {
  [(PathBoxesAppDelegate *)[[UIApplication sharedApplication] delegate] setAuthToken:nil];
  //self.url = nil;
  responceData = nil;
  [self loadDataFromCacheIfAvailable];
  [self configureNavigationBar];
  [self.tableView reloadData];
  [[ASIDownloadCache sharedCache] clearSession];
  [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}

-(void) userDidLogin:(id)dender {
  [self performSelector:@selector(xxx)withObject:nil afterDelay:.75];

  [self configureNavigationBar];
}

#pragma mark View LifeCycle
- (void) viewDidLoad {
  [super viewDidLoad];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(userDidLogin:)
                                               name:@"USER_LOGGED_IN" object:nil];
  
  self.navigationItem.title = NSLocalizedString(@"PicBounce",@"PICBOUNCE TITLE");
    
    UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage //imageNamed:@"bg_grey.png"]];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //[self.tableView.backgroundView addSubview:[self headerForAboveTableView:self.tableView]]; 
  //[self.tableView.backgroundView addSubview:[self footerForBelowTableView:self.tableView]]; 
  self.tableView.tableFooterView = [self footerViewForTable:self.tableView];
  
  
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configureNavigationBar];
}





#pragma mark Table View Layout and Sizes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return [[responceData photos] count] + 1;  // person + photos + load more
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) { //user
    return 0;
  }
  if (section == 1) { //photos
    return 42; //Photo headers
  }
  if (section == 2) { //load more
    return 0;
  }
  
} 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
  if (indexPath.section == 0) {
    return 0;
  }
  else {
    return [PBPhotoCell height];
  } 
}

#pragma mark Cells and Headers
- (UIImageView *) headerForAboveTableView:(UITableView *)tableView {
  UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
  header.image = [UIImage imageNamed:@"bg_grey.png"];
  //header.backgroundColor = [UIColor blueColor];
    return nil; //[header autorelease];
}

- (UIImageView *) footerForBelowTableView:(UITableView *)tableView {
  UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 367, 320, 200)];
  footer.image = [UIImage imageNamed:@"bg_grey.png"];
  //footer.backgroundColor = [UIColor redColor];
  return footer;
}

- (UIView *) footerViewForTable:(UITableView *)tableView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    footerView.backgroundColor = [UIColor clearColor];
    loadingMoreActivityIndicatiorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingMoreActivityIndicatiorView.frame = CGRectMake(0, 0, 20, 20);
    loadingMoreActivityIndicatiorView.hidesWhenStopped = YES;
    [loadingMoreActivityIndicatiorView stopAnimating];
    footerDecoration = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hr_end.png"]] autorelease]; 
    footerDecoration.hidden = YES;
    footerDecoration.contentMode = UIViewContentModeTop;
    footerDecoration.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 40);
    loadingMoreActivityIndicatiorView.center = CGPointMake( footerView.center.x ,  footerView.center.y - 10);
    [footerView addSubview:footerDecoration];
    [footerView addSubview:loadingMoreActivityIndicatiorView];
  return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return nil;
  }
  [[NSBundle mainBundle] loadNibNamed:@"PBHeaderTableViewCell" owner:self options:nil];
  
 
  NSDictionary *photo = [responceData photoAtIndex:section];
  NSDictionary *user = [photo objectForKey:@"user"];
  
  
  //id y = [x objectForKey:@"photo"];
  // NSString *caption = [y objectForKey:@"caption"];
  // NSString *viewCount = [y objectForKey:@"view_count"];
  // NSString *uuid = [y objectForKey:@"uuid"];
  
  NSString *name = [user objectForKey:@"display_name"];
  NSString *lastLocation = [user objectForKey:@"last_location"];
  NSString *avatarURL = [photo objectForKey:@"twitter_avatar_url"];
  
  headerTableViewCell.nameLabel.text = name;
  headerTableViewCell.locationLabel.text = lastLocation;
  headerTableViewCell.timeLabel.text = [responceData timeLabelTextForPhotoAtIndex:section-1];
  if (![avatarURL isEqual:[NSNull null]]) {
     headerTableViewCell.avatarImage.imageURL = [NSURL URLWithString: avatarURL];
  }
 
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personHeaderViewWasTapped:)];
  [headerTableViewCell addGestureRecognizer:tapRecognizer];
  [tapRecognizer release];
  return headerTableViewCell;
}

- (UITableViewCell *)profileHeaderCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *userData = nil;
  if ([[data class] isSubclassOfClass:[NSArray class]]) {
    userData = nil;
  }
  else if ([[data class] isSubclassOfClass:[NSDictionary class]]){
    userData = [(NSDictionary*) data objectForKey:@"user"];
   // id badges_count = [userData objectForKey:"badges_count"];
  }

  id photo = nil;//[responceData photoAtIndex:indexPath.section];
  
  NSString *avatarURL = [photo objectForKey:@"twitter_avatar_url"];
  
  static NSString *MyIdentifier = @"CELL";
  
  PBProfileHeaderCell *_cell = (PBProfileHeaderCell *) [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (_cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderCell" owner:self options:nil];
    _cell = (PBProfileHeaderCell *)cell;
    // self.tvCell = nil;
  }
  
  UITapGestureRecognizer *tapRecoginizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfilePhotoButtonPressed:)];
  [_cell.avatarIcon addGestureRecognizer:tapRecoginizer];
  
  profileAvatarImageView = _cell.avatarIcon;
    
    
//  if (shouldShowProfileHeaderBeforeNetworkLoad && ([data count] < 1)) {
  if (preloadedName) {
    _cell.followersCountLabel.text = @"";
    _cell.badgesCountLabel.text = @"";
    _cell.followingCountLabel.text = [NSString stringWithFormat:@"%d", [[userData objectForKey:@"following_count"] intValue]];
    _cell.photosCountLabel.text = [NSString stringWithFormat:@"%d", [[userData objectForKey:@"photo_count"] intValue]];
    _cell.nameLabel.text = preloadedName;
    _cell.locationLabel.text = preloadedLocation;
    _cell.avatarIcon.imageURL = preloadedAvatarURL;
    _cell.avatarIcon.backgroundColor = [UIColor redColor];
    if (YES) {
        NSString *_url = avatarURL;
      if (![_url isEqual:[NSNull null]]) {
        _cell.avatarIcon.imageURL = [NSURL URLWithString:_url];
      }
    }
    
  }
  else {
    _cell.followersCountLabel.text = @"X";
    _cell.badgesCountLabel.text = @"X";
    _cell.followingCountLabel.text = @"X";
    _cell.photosCountLabel.text = [userData objectForKey:@"photo_count"];
    _cell.nameLabel.text = @"Micheal Sorrentino";
    _cell.locationLabel.text = @"XXXXXX";
    _cell.avatarIcon.imageURL = [NSURL URLWithString: @"http://a2.twimg.com/profile_images/1225485762/image_normal.jpg"];
  }  
  return _cell;
}

- (UITableViewCell *)photoHeaderCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *arrayOfPhotos = [responceData photos];
 
  
  
  id photo = nil;
  if (indexPath.section > 0) {
    photo = [arrayOfPhotos objectAtIndex:(indexPath.section)-1];
  }
  
  
  
  NSString *caption = [photo objectForKey:@"caption"];
  NSString *viewCount = [photo objectForKey:@"view_count"];
  NSString *uuid = [photo objectForKey:@"uuid"];
  NSString *twitter_avatar_url = [photo objectForKey:@"twitter_avatar_url"];
  if ([twitter_avatar_url isEqual:[NSNull null]]) {
    twitter_avatar_url = nil;
  }
  
  static NSString *MyIdentifier = @"CELL";
  
  PBPhotoCell *_cell = (PBPhotoCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (_cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
    _cell = cell;
    // self.tvCell = nil;
  }
  
  _cell.tableViewController = self;
  _cell.avatarImageView.imageURL = [NSURL URLWithString:twitter_avatar_url];
  
  _cell.photoImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://s3.amazonaws.com/com.clixtr.picbounce/photos/%@/big.jpg",uuid]];
  _cell.viewCountLabel.text = [NSString stringWithFormat:@"Views: %@",viewCount];
  _cell.bounceCountLabel.text = [NSString stringWithFormat:@"%d",19];
  _cell.commentCountLabel.text = [NSString stringWithFormat:@"View all %d comments",50];
  if (![caption isEqual:[NSNull null]])
    _cell.commentLabel.text = caption;
  else
    _cell.commentLabel.text = @"";
  return cell;  
}

- (UITableViewCell *)infoHeaderCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  [[NSBundle mainBundle] loadNibNamed:@"TableTitleTableViewCell" owner:self options:nil];
  tableTitleTableViewCell.textLabel.text = [NSString stringWithFormat:@"Following %d people",[responceData followingCount]];
  return tableTitleTableViewCell;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0  && shouldShowProfileHeader) {
    return [self profileHeaderCellForRowAtIndexPath:indexPath];
  }
  
  return [self photoHeaderCellForRowAtIndexPath:indexPath];
}


#pragma mark Other UI 
-(UITextView *) commentTextView {
  commentTextField = [[UITextView alloc] initWithFrame:CGRectZero];
  commentTextField.backgroundColor = [UIColor darkGrayColor];
  commentTextField.alpha = 0.9;
  commentTextField.layer.cornerRadius = 5;
  commentTextField.contentInset = UIEdgeInsetsMake(4,0,4,4);
  commentTextField.userInteractionEnabled = YES;
  UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  cancel.frame = CGRectMake(0, 192-30, 50, 30);
  [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
  [cancel addTarget:self action:@selector(cancelCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  UIButton *send = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  send.frame = CGRectMake(300-50, 192-30, 50, 30);
  [send setTitle:@"Send" forState:UIControlStateNormal];
  [send addTarget:self action:@selector(sendCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  [commentTextField addSubview:cancel];
  [commentTextField addSubview:send];
  
  return commentTextField;
}



-(void) closeCommentBox {
  [UIView beginAnimations:@"" context:nil];
  [commentTextField resignFirstResponder];
  commentTextField.alpha = 0;
  activeLeaveCommentButton.alpha = 1;
  [UIView commitAnimations];
}

#pragma mark Data
-(BOOL) moreDataAvailable {
  if ([responceData loadMoreDataURL]) {
    footerDecoration.hidden = YES;
    [loadingMoreActivityIndicatiorView startAnimating];
    return YES; 
  }
  else {
    [loadingMoreActivityIndicatiorView stopAnimating];
    footerDecoration.hidden = NO;
    return NO;
  }
}

-(void) loadMoreData {
  footerDecoration.hidden = YES;
  [loadingMoreActivityIndicatiorView startAnimating];
  loadMoreDataURL = [responceData loadMoreDataURL];
  [self loadMoreFromNetwork];
  //[self performSelector:@selector(moreDataDidLoad) withObject:nil afterDelay:8.0];
}

-(void) moreDataDidLoad {
  [loadingMoreActivityIndicatiorView stopAnimating];
  footerDecoration.hidden = NO;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self numberOfSectionsInTableView:tableView] - 1) {
      if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        if ([data count] > 0) {
          if ([self moreDataAvailable]) {
            [self loadMoreData];
          }
      }
    }
  }
}




#pragma mark Buttons and Gesture Recoginizers
-(void) cancelCommentButtonPressed:(id)sender {
  self.tableView.userInteractionEnabled = YES;
  [self closeCommentBox];
}

-(void) sendCommentButtonPressed:(id)sender {
  self.tableView.userInteractionEnabled = YES;
  [self closeCommentBox];
}

-(IBAction) leaveCommentButtonPressed:(UIButton *) sender {
  PBCommentListViewController *vc = [[PBCommentListViewController alloc] initWithNibName:@"PBCommentListViewController" bundle:nil];
   vc.hidesBottomBarWhenPushed = YES;
   [self.navigationController pushViewController:vc animated:YES];
   
  
  return;
  commentTextField = [self commentTextView];
  
  CGRect rect = [sender.superview convertRect:sender.frame toView:self.tableView];  
  CGRect rect2 = [self.tableView convertRect:rect toView:self.tableView.superview];
  commentTextField.frame = rect2;
  [self.tableView.superview  addSubview:commentTextField];
  sender.alpha = 0;
  activeLeaveCommentButton = sender;
  //[self.tableView.superview addSubview:sender];
  
  CGFloat btnBottm = rect2.origin.y+rect2.size.height;
  CGFloat xx = 195 - btnBottm;
  commentTextField.alpha = 0.9;
  
  [UIView beginAnimations:@"" context:nil];
  [UIView setAnimationDuration:0.33];
  self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y-xx);
  self.tableView.userInteractionEnabled = NO;
  [commentTextField becomeFirstResponder];
  
  commentTextField.frame = CGRectMake(10, 3, 300, 192);
  [UIView commitAnimations];
}


-(void) personHeaderViewWasTapped:(UITapGestureRecognizer *)sender {
 /* PBCommentListViewController *vc = [[PBCommentListViewController alloc] initWithNibName:@"PBCommentListViewController" bundle:nil];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
  
  
  return;*/
  //TODO
  //[self pushNewStreamViewControllerWithPerson:(NSString *)person];
  PBHeaderTableViewCell *view = (PBHeaderTableViewCell *)sender.view;
  
  PBStreamViewController *new = [[PBStreamViewController alloc] init];
  //new.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/%@/profile",API_BASE,view.nameLabel.text]];
  
  
  new.shouldShowProfileHeaderBeforeNetworkLoad = YES;
  new.shouldShowProfileHeader = YES;
  new.preloadedLocation = view.locationLabel.text;
  new.preloadedName = view.nameLabel.text;
  new.preloadedAvatarURL = view.avatarImage.imageURL;
  new.title = @"NAME";
  [self.navigationController pushViewController:new animated:YES];
  //[new release];
}

-(IBAction) photosButtonPressed {
  if (([self numberOfSectionsInTableView:self.tableView] > 1)) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
}

-(IBAction) followingButtonPressed { 
  NSURL *followingURL = [responceData followingURL];
  if (followingURL) {
    PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
    //vc.url = followingURL;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release]; 
  }
}

-(IBAction) followersButtonPressed {
  //NSURL *followersURL = [responceData followersURL];
  //if (followersURL) {
    PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
    //vc.url = followersURL;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release]; 
  //}  
}

-(IBAction) taggedPeopleButtonPressed:(id)sender {
  PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
  //vc.url = followersURL;
  [self.navigationController pushViewController:vc animated:YES];
  [vc release]; 
}
-(IBAction) badgesButtonPressed {
  PBBadgeCollectionViewController *vc = [[PBBadgeCollectionViewController alloc] initWithNibName:@"PBBadgeCollectionViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}


//Follow 
-(IBAction) followButtonPressed:(UIButton *) sender {
 
  
  ASIFormDataRequest *followRequest = [ASIFormDataRequest requestWithURL:[responceData followUserURLForUser]];
  followRequest.requestMethod = @"POST";
  [followRequest setPostValue:@"1" forKey:@"id"];
  [followRequest startAsynchronous];
  
}

-(IBAction) bounceButtonPressed:(id) sender {
  }


-(IBAction) loginButtonPressed:(id)sender {
  
  
  PBLoginViewController *loginViewController = [[PBLoginViewController alloc] initWithNibName:@"PBLoginViewController" bundle:nil];
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
  
  [self presentModalViewController:navigationController animated:YES];
  [navigationController release];
  
}


-(IBAction) settingsButtonPressed:(id)sender{
   
    
    
    ProfileSettingView *profile1 = [[[ProfileSettingView alloc]initWithNibName:nil bundle:nil]autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:profile1] autorelease];
      
    [self presentModalViewController:navController animated:YES];
    

}
-(IBAction) changeProfilePhotoButtonPressed:(id) sender {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Change Profile Photo"
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel" 
                                             destructiveButtonTitle:nil 
                                                  otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
  [actionSheet showInView:self.tabBarController.view];
  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
 if (buttonIndex == 0) {
   UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
   imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
   imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
   imagePicker.allowsEditing = YES;
   imagePicker.delegate = self;
  
   [self presentModalViewController:imagePicker animated:YES];
 } 
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  profileAvatarImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
}



@end
