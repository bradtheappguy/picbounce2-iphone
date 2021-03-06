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
#import "PBUploadingTableViewCell.h"
#import "PBPersonListViewController.h"
#import "PBHTTPRequest.h"
#import "NewPostViewController.h"
#import "NSDictionary+NotNull.h"
#import "PBNavigationController.h"

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

- (UIView *)createDefaultView {
   
    UIView *a_EmptyStateView; 
    if (self.tabBarController.selectedIndex == 2) {
        a_EmptyStateView = [[UIView alloc] initWithFrame:CGRectMake(0,_profileHeader.frame.size.height +5, self.view.bounds.size.width, self.view.bounds.size.height)];
    }else
    a_EmptyStateView = [[UIView alloc] initWithFrame:CGRectMake(0,5 , self.view.bounds.size.width, self.view.bounds.size.height)];
    a_EmptyStateView.tag = -37;
    a_EmptyStateView.layer.masksToBounds = YES;
    a_EmptyStateView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:a_EmptyStateView];
    self.tableView.scrollEnabled = NO;
    
    UIImageView *emptyView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    emptyView.tag = 12;
  emptyView.backgroundColor = [UIColor colorWithRed:240/255.0 green:237/255.0 blue:235/255.05 alpha:1];
    emptyView.image = [UIImage imageNamed:@"ico_feed_empty.png"];
  emptyView.contentMode = UIViewContentModeCenter;
    [a_EmptyStateView addSubview:emptyView];
    [emptyView release];
    
    
    UILabel *a_DefaultViewNameLabel = [[UILabel alloc]initWithFrame: CGRectMake(26, 77, 268, 32)];
    a_DefaultViewNameLabel.text = [NSString stringWithFormat:@"Welcome, %@",self.navigationItem.title];
    a_DefaultViewNameLabel.backgroundColor = [UIColor clearColor];
    a_DefaultViewNameLabel.textAlignment = UITextAlignmentCenter;
    a_DefaultViewNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:26];
    a_DefaultViewNameLabel.textColor = [UIColor colorWithRed:77.0f/255.0f green:52.0f/255.0f blue:49.0f/255.0f alpha:1.0];
    [a_EmptyStateView addSubview:a_DefaultViewNameLabel];
    [a_DefaultViewNameLabel release];
    
    UILabel *a_DefaultViewNameLabel1 = [[UILabel alloc]initWithFrame: CGRectMake(93, 247, 135, 58)];
    a_DefaultViewNameLabel1.numberOfLines = 2;
    a_DefaultViewNameLabel1.text = @"Snap a photo   to start sharing!";
    a_DefaultViewNameLabel1.textColor = [UIColor colorWithRed:77.0f/255.0f green:52.0f/255.0f blue:49.0f/255.0f alpha:1.0];
    a_DefaultViewNameLabel1.backgroundColor = [UIColor clearColor];
    a_DefaultViewNameLabel1.textAlignment = UITextAlignmentCenter;
    a_DefaultViewNameLabel1.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [a_EmptyStateView addSubview:a_DefaultViewNameLabel1];
    [a_DefaultViewNameLabel1 release];
    return [a_EmptyStateView autorelease];
}
-(void) showEmptyState {

    [self.tableView addSubview:[self createDefaultView]]; 
    self.tableView.scrollEnabled = NO;
}


-(void) hideEmptyState {
       
        [[self.view viewWithTag:-37] removeFromSuperview];
        //[self.tableView addSubview:[self createDefaultView]];
    
    self.tableView.scrollEnabled = YES;
}

- (void) reload {
  [self.tableView reloadData];
  
  NSDictionary *user = [self.responseData user];
  NSString *name = [user objectForKeyNotNull:@"screen_name"]; 
  if (name) {
    self.navigationItem.title = name;
  }
  if (user && shouldShowProfileHeader) {
    self.tableView.tableHeaderView = shouldShowFollowingBar?self.profileHeaderWithFollowBar:self.profileHeader;
    [self.profileHeader setUser:user];
  }
  else {
    UIView *transparentHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    transparentHeader.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = transparentHeader;
    [transparentHeader release];
  }    

  if ([self numberOfSectionsInTableView:self.tableView] == 0) {
    [self showEmptyState];
  }
  else {
    [self hideEmptyState];
  }
  [self configureNavigationBar];
  
  if ([self.responseData loadMoreDataURL]) {
    [footerView setBottomReachedIndicatorHidden:YES];
    [footerView startLoadingAnimation];
  }
  else {
    [footerView setBottomReachedIndicatorHidden:NO];
    [footerView stopLoadingAnimation];
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
  [self loadDataFromCacheIfAvailable];
}


-(void) awakeFromNib {
  if (self.shouldShowUplodingItems) {
    [[PBUploadQueue sharedQueue] addObserver:self forKeyPath:@"count" options:NSKeyValueChangeSetting context:nil];
  }
}

-(void) configureNavigationBar {
  UILabel *l = (UILabel *)self.navigationItem.titleView;
  if ([l.text isEqualToString:self.navigationItem.title] == NO) {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = kNavBarTitleTextColor
    self.navigationItem.titleView = label;
    label.text = self.navigationItem.title;
    [label sizeToFit];
  }
   
  
  UIBarButtonItem *createPostButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createPost)];
  self.navigationItem.rightBarButtonItem = createPostButton;
  [createPostButton release];
}

#pragma mark Open Create Post View
- (void)createPost {
    NewPostViewController *newPostViewController = [[NewPostViewController alloc] initWithNibName:@"NewPostViewController" bundle:nil];
    newPostViewController.hidesBottomBarWhenPushed = YES;
  PBNavigationController *navigationController = [[PBNavigationController alloc] initWithRootViewController:newPostViewController style:1];
        
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
  newPostViewController.navigationItem.leftBarButtonItem = cancelButton;
  newPostViewController.navigationItem.title = @"New Post";
  [cancelButton release];
  [self presentModalViewController:navigationController animated:YES];
    [newPostViewController release];
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
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoadingIndicator11) name:@"ShowLoadingView" object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoadingIndicator11) name:@"HideLoadingView" object:nil];
  [self.profileHeader.followButton setViewController:self];
  
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:@"USER_LOGGED_IN" object:nil];
  
  if (!self.navigationItem.title) {
      NSLog(@"%@", NSLocalizedString(@"PicBounce",@"PICBOUNCE TITLE"));
      self.navigationItem.title = NSLocalizedString(@"PicBounce",@"PICBOUNCE TITLE");
  }
  
  UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tableFooterView = [self footerViewForTable:self.tableView];
  
        //self.tableView.tableFooterView = [self footerViewForTable:self.tableView];
    [self configureNavigationBar];
  
}


#pragma mark Table View Layout and Sizes

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  NSUInteger nUploading = [[PBUploadQueue sharedQueue] count]; 
  NSUInteger nPhotos = [[self.responseData posts] count]; 
  
  NSUInteger nSections = nPhotos;
  if (self.shouldShowUplodingItems) {
    nSections += nUploading;
  }
  return nSections;
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
/*
 if (self.shouldShowUplodingItems == NO) {
 return [self photoCellForRowAtIndex:indexPath.section];
 }
 else {
 NSUInteger count = [[PBUploadQueue sharedQueue] count];
 if (indexPath.section >= count) {
 return [self photoCellForRowAtIndex:indexPath.section - count];
 }  
 */


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
  if (self.shouldShowUplodingItems == NO) {
    return [PBPhotoCell heightWithPhoto:[self.responseData photoAtIndex:indexPath.section]];
  }
  else {
    NSUInteger count = [[PBUploadQueue sharedQueue] count];
    if (indexPath.section >= count) {
      return [PBPhotoCell heightWithPhoto:[self.responseData photoAtIndex:indexPath.section - count]];
    }  
    else {
      return 65;
    }
  }
}


#pragma mark Cells and Headers
//Load more 
- (PBLoadMoreTablewViewFooter *) footerViewForTable:(UITableView *)tableView {
  if (!footerView) {
    footerView = [[PBLoadMoreTablewViewFooter alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 70)];
  }
  return footerView;
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

-(UITableViewCell *)loadMoreCell {
  UITableViewCell *loadMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LOADMORECELL"];
  loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [[loadMoreCell contentView] addSubview:spinner];
  [spinner startAnimating];
  spinner.center = loadMoreCell.center;
  [spinner release];
  return loadMoreCell;
}



- (UITableViewCell *)photoCellForRowAtIndex:(NSUInteger)index {
  id photo = [self.responseData photoAtIndex:index];
  
  if (!photo) {
    return [self loadMoreCell];
  }
  
  
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
  PBUploadingTableViewCell *upcell = [[[NSBundle mainBundle] loadNibNamed:@"PBUploadingTableViewCell" owner:nil options:nil] lastObject];
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
  if ([self.responseData loadMoreDataURL]) {
    return YES; 
   }
   else {
     return NO;
   }
}

-(void) loadMoreData {
  [footerView startLoadingAnimation];
  [footerView setBottomReachedIndicatorHidden:YES];
  [self loadMoreFromNetwork];
}

-(void) moreDataDidLoad {

}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == [self numberOfSectionsInTableView:tableView] - 1) {
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
      if ([self.responseData numberOfPosts] > 0) {
        if ([self moreDataAvailable]) {
          [self loadMoreData];
        }
      }
    }
  }
}


-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self reloadTableViewDataSourceUsingCache:NO];
  //[self configureNavigationBar];
}


-(void) pushNewStreamViewControllerWithUserID:(NSString *)userID screenName:(NSString*)screenName {
  
  PBStreamViewController *vc = [[PBStreamViewController alloc] initWithNibName:@"PBStreamViewController" bundle:nil];
  vc.baseURL = [NSString stringWithFormat:@"http://%@/api/users/%@/posts",API_BASE,userID];
  vc.shouldShowFollowingBar = YES;
  vc.shouldShowProfileHeader = YES;
  vc.shouldShowProfileHeaderBeforeNetworkLoad = YES;
  vc.pullsToRefresh = YES;
  vc.navigationItem.title = screenName;
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}

#pragma mark Buttons and Gesture Recoginizers

-(void) personHeaderViewWasTapped:(UITapGestureRecognizer *)sender {
  PBPhotoHeaderView *header = (PBPhotoHeaderView *)sender.view;
  NSString *screenName = [[header.photo objectForKey:@"user"] objectForKeyNotNull:@"screen_name"];
  [self pushNewStreamViewControllerWithUserID:header.userID screenName:screenName];
}


-(IBAction) photosButtonPressed {
  if (([self numberOfSectionsInTableView:self.tableView] > 0)) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] setCurrentController:self];
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentLoginViewController:NO];
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

-(void) showLoadingIndicator11 {
    if (loadingView) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 108, 58)];
    loadingView.layer.cornerRadius = 10;
    loadingView.backgroundColor = [UIColor colorWithRed:144/255.0 green:124/255.0 blue:109/255.0 alpha:0.90];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(108/2, 20);
    [spinner startAnimating];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 108, 15)];
    loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    loadingLabel.textColor = [UIColor colorWithRed:252/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.text = @"Loading";
    loadingLabel.backgroundColor = [UIColor clearColor];
    
    [loadingView addSubview:spinner];
    [spinner release];
    [loadingView addSubview:loadingLabel];
    [loadingLabel release];
    loadingView.center = self.view.center;
    [self.view  addSubview:loadingView];
    
}
- (void)hideLoadingIndicator11 {
    if (loadingView) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
}
@end
