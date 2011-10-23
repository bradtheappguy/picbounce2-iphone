//
//  PBProfileViewController.m
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#define CELL_PADDING 15
#import "PBCommentListViewController.h"
#import "ProfileSettingView.h"
#import "PBLoginViewController.h"
#import "AppDelegate.h"
#import "ASIDownloadCache.h"
#import "PBPhotoCell.h"
#import "PBPhotoHeaderView.h"
#import "PBUploadQueue.h"
#import "PBStreamViewController.h"
#import "PBUploadingPhotoTableViewCell.h"
#import "PBPersonListViewController.h"
#import "PBHTTPRequest.h"

@implementation PBStreamViewController

@synthesize shouldShowProfileHeader;
@synthesize shouldShowProfileHeaderBeforeNetworkLoad;
@synthesize profileHeaderWithFollowBar;
@synthesize shouldShowFollowingBar;
@synthesize shouldShowUplodingItems;

@synthesize segmentedControl;

@synthesize preloadedAvatarURL;
@synthesize preloadedLocation;
@synthesize preloadedName;
@synthesize setting;

@synthesize profileHeader = _profileHeader;
@synthesize avatarIcon;
@synthesize nameLabel;
@synthesize locationLabel;
@synthesize photosCountLabel;
@synthesize followersCountLabel;
@synthesize followingCountLabel;
@synthesize badgesCountLabel;


-(void) showEmptyState {
  UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  emptyView.backgroundColor = [UIColor redColor];
  [self.view addSubview:emptyView];
  self.tableView.scrollEnabled = NO;
}


-(void) hideEmptyState {
  self.tableView.scrollEnabled = YES;
}

- (void) reload {
  [self.tableView reloadData];
  
  NSDictionary *user = [self.responseData user];
  self.navigationItem.title = [user objectForKey:@"screen_name"]; 
  
  if (user && shouldShowProfileHeader) {
    self.tableView.tableHeaderView = shouldShowFollowingBar?self.profileHeaderWithFollowBar:self.profileHeader;
    [self.profileHeader setUser:user];
  }
  else {
    self.tableView.tableHeaderView = nil;
  }    

  if ([self numberOfSectionsInTableView:self.tableView] == 0) {
    [self showEmptyState];
  }
  else {
    [self hideEmptyState];
  }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {  
  if ([[PBUploadQueue sharedQueue] count] == 0 ) {
    [self reloadTableViewDataSourceUsingCache:NO];
  }
  else {
    [self reload];
  }
}

-(void)xxx {
  [self dismissModalViewControllerAnimated:YES];
  [self loadDataFromCacheIfAvailable];
}


-(void) awakeFromNib {
  if (self.shouldShowUplodingItems) {
    [[PBUploadQueue sharedQueue] addObserver:self forKeyPath:@"count" options:NSKeyValueChangeSetting context:nil];
  }
}

-(void) configureNavigationBar {
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  [backButton release];
  //UIBarButtonItem *settings  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings",nil) style:UIBarButtonItemStyleBordered target:self //action:@selector(settingsButtonPressed:)];
  //self.navigationItem.rightBarButtonItem = settings; 
  if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] authToken]) {
    UIBarButtonItem *logoutButton  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
    self.navigationItem.leftBarButtonItem = nil;
  }
  else {
    UIBarButtonItem *loginButton  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(loginButtonPressed:)];
    self.navigationItem.leftBarButtonItem = loginButton;
    [loginButton release];
    self.navigationItem.rightBarButtonItem = nil;
  }
  
}

- (void) logoutButtonPressed:(id)sender {
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] setAuthToken:nil];
  //self.url = nil;
  self.responseData = nil;
  self.tableView.tableHeaderView = nil;
  [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
  [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  [ASIHTTPRequest setSessionCookies:nil];
  [self loadDataFromCacheIfAvailable];
  [self configureNavigationBar];
  [self.tableView reloadData];
  [self loginButtonPressed:nil];
}

-(void) userDidLogin:(id)dender {
  [self performSelector:@selector(xxx)withObject:nil afterDelay:.75];
  [self configureNavigationBar];
}

#pragma mark View LifeCycle
- (void) viewDidLoad {
  [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:@"USER_LOGGED_IN" object:nil];
  
  if (!self.navigationItem.title) {
    self.navigationItem.title = NSLocalizedString(@"PicBounce",@"PICBOUNCE TITLE");
  }
  
  UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tableFooterView = [self footerViewForTable:self.tableView];
  
  self.tableView.tableFooterView = [self footerViewForTable:self.tableView];

  [self configureNavigationBar];
  
}


#pragma mark Table View Layout and Sizes

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  NSUInteger nUploading = [[PBUploadQueue sharedQueue] count]; 
  NSUInteger nPhotos = [[self.responseData posts] count]; 
  if (self.shouldShowUplodingItems) {
    return nUploading + nPhotos;
  }
  else {
    return nPhotos;
  }
}

//one row for each photo
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (self.shouldShowUplodingItems == NO) {
    return 42;
  }
  else {
    if (section >= [[PBUploadQueue sharedQueue] count]) {
      return 42;
    }  
    else {
      return 0;
    }
  }
} 



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
  if (self.shouldShowUplodingItems == NO) {
    return [PBPhotoCell heightWithPhoto:nil];
  }
  else {
    if (indexPath.section >= [[PBUploadQueue sharedQueue] count]) {
      return [PBPhotoCell heightWithPhoto:nil];
    }  
    else {
      return 65;
    }
  }
}


#pragma mark Cells and Headers
//Load more 
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
  return [footerView autorelease];
}


//Photo Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  NSDictionary *photo = [self.responseData photoAtIndex:section];
  
  
  [[NSBundle mainBundle] loadNibNamed:@"PBPhotoHeaderView" owner:self options:nil];
  [photoHeader setPhoto:photo];
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personHeaderViewWasTapped:)];
  [photoHeader addGestureRecognizer:tapRecognizer];
  [tapRecognizer release];
  return photoHeader;
}




- (UITableViewCell *)photoCellForRowAtIndex:(NSUInteger)index {
  id photo = [self.responseData photoAtIndex:index];
  
  
  
  static NSString *MyIdentifier = @"CELL";
  PBPhotoCell *_cell = (PBPhotoCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (_cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"PBPhotoCell" owner:self options:nil];
    _cell = cell;
    // self.tvCell = nil;
  }
  [_cell setPhoto:photo];
  
  _cell.tableViewController = self;
  

  return cell;
}


-(UITableViewCell *) uploadingCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PBUploadingPhotoTableViewCell *upcell = [[[NSBundle mainBundle] loadNibNamed:@"PBUploadingPhotoTableViewCell" owner:nil options:nil] lastObject];
  NSDictionary *photo = [[PBUploadQueue sharedQueue] photoAtIndex:indexPath.section];
  [upcell setPhoto:photo];
  return upcell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.shouldShowUplodingItems == NO) {
    return [self photoCellForRowAtIndex:indexPath.section];
  }
  else {
    NSUInteger count = [[PBUploadQueue sharedQueue] count];
    if (indexPath.section >= count) {
      return [self photoCellForRowAtIndex:indexPath.section - count];
    }  
    else {
      return [self uploadingCellForRowAtIndexPath:indexPath];
    }
  }
}



#pragma mark Data
-(BOOL) moreDataAvailable {
  /*if ([responseData loadMoreDataURL]) {
   footerDecoration.hidden = YES;
   [loadingMoreActivityIndicatiorView startAnimating];
   return YES; 
   }
   else {
   [loadingMoreActivityIndicatiorView stopAnimating];
   footerDecoration.hidden = NO;
   return NO;
   }*/return NO;
}

-(void) loadMoreData {
  footerDecoration.hidden = YES;
  [loadingMoreActivityIndicatiorView startAnimating];
  //loadMoreDataURL = [responseData loadMoreDataURL];
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
      //if ([data count] > 0) {
      //if ([self moreDataAvailable]) {
      //[self loadMoreData];
      //}
      //}
    }
  }
}


-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self reloadTableViewDataSourceUsingCache:NO];
}




#pragma mark Buttons and Gesture Recoginizers

-(void) personHeaderViewWasTapped:(UITapGestureRecognizer *)sender {
  PBPhotoHeaderView *header = (PBPhotoHeaderView *)sender.view;
  PBStreamViewController *vc = [[PBStreamViewController alloc] initWithNibName:@"PBStreamViewController" bundle:nil];
  vc.baseURL = [NSString stringWithFormat:@"http://%@/users/%@.json?auth_token=%@",API_BASE,header.userID,[(AppDelegate *)[[UIApplication sharedApplication] delegate] authToken]];
  vc.shouldShowFollowingBar = YES;
  vc.shouldShowProfileHeader = YES;
  vc.shouldShowProfileHeaderBeforeNetworkLoad = YES;
  vc.pullsToRefresh = YES;
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}


-(IBAction) photosButtonPressed {
  if (([self numberOfSectionsInTableView:self.tableView] > 0)) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
}

-(IBAction) followingButtonPressed { 
  NSString *followingURL = [self.responseData followingURL];
  if (followingURL) {
    PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
    vc.title = @"Following";
    vc.baseURL = followingURL;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release]; 
  }
}

-(IBAction) followersButtonPressed {
  NSString *followersURL = [self.responseData followersURL];
  if (followersURL) {
    PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
    vc.title = @"Followers";
    vc.baseURL = followersURL;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
  }  
}

-(IBAction) taggedPeopleButtonPressed:(id)sender {
  //PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
  //vc.url = followersURL;
  //[self.navigationController pushViewController:vc animated:YES];
  //[vc release]; 
}
-(IBAction) badgesButtonPressed {
  //PBBadgeCollectionViewController *vc = [[PBBadgeCollectionViewController alloc] initWithNibName:@"PBBadgeCollectionViewController" bundle:nil];
  //[self.navigationController pushViewController:vc animated:YES];
  //[vc release];
}







-(IBAction) loginButtonPressed:(id)sender {
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentLoginViewController];
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
  [actionSheet release];
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

-(IBAction)leaveCommentButtonPressed:(id)sender{}


@end
