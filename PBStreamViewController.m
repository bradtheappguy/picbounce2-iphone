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
#import "PBHeaderTableViewCell.h"

#import "PBStreamViewController.h"

@implementation PBStreamViewController

@synthesize shouldShowProfileHeader;
@synthesize shouldShowProfileHeaderBeforeNetworkLoad;
@synthesize shouldShowFollowingBar;
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


- (void) reload {
  [self.tableView reloadData];
  if (shouldShowProfileHeader) {
    NSDictionary *user = [self.responceData user];
    self.navigationItem.title = [user objectForKey:@"screen_name"]; 
                  
    NSString *name = [user objectForKey:@"display_name"];
    //BOOL followingMe = [(NSNumber *)[user objectForKey:@"follows_me"] boolValue];
    //BOOL following = [(NSNumber *)[user objectForKey:@"following"] boolValue];
    
    NSNumber *followingCount = [user objectForKey:@"following_count"];
    NSNumber *followersCount = [user objectForKey:@"followers_count"];
    NSNumber *photosCount = [user objectForKey:@"photo_count"];
    
    
    
    self.profileHeader.nameLabel.text = name;
    [self.profileHeader.photoCountButton setTitle:[photosCount stringValue] forState:UIControlStateNormal];
    [self.profileHeader.followersCountButton setTitle:[followersCount stringValue] forState:UIControlStateNormal];
    [self.profileHeader.followingCountButton setTitle:[followingCount stringValue] forState:UIControlStateNormal];
    
  }
  
}


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
  self.responceData = nil;
  [self loadDataFromCacheIfAvailable];
  [self configureNavigationBar];
  [self.tableView reloadData];
  	[[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
  [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}

-(void) userDidLogin:(id)dender {
  [self performSelector:@selector(xxx)withObject:nil afterDelay:.75];
  [self configureNavigationBar];
}

#pragma mark View LifeCycle
- (void) viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:@"USER_LOGGED_IN" object:nil];
  self.navigationItem.title = NSLocalizedString(@"PicBounce",@"PICBOUNCE TITLE");
  UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tableFooterView = [self footerViewForTable:self.tableView];
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configureNavigationBar];
  if (shouldShowProfileHeader) {
    self.tableView.tableHeaderView = self.profileHeader;
  }
}


#pragma mark Table View Layout and Sizes

//one section for each photo
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return [[self.responceData photos] count];  // person + photos + load more
}

//one row for each photo
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 42;
} 



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return [PBPhotoCell height];
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
  [[NSBundle mainBundle] loadNibNamed:@"PBHeaderTableViewCell" owner:self options:nil];
  
 
  NSDictionary *photo = [self.responceData photoAtIndex:section];
  NSDictionary *user = [photo objectForKey:@"user"];

  NSString *name = [user objectForKey:@"display_name"];
  NSString *lastLocation = [user objectForKey:@"last_location"];
  NSString *avatarURL = [photo objectForKey:@"twitter_avatar_url"];
  
  headerTableViewCell.nameLabel.text = name;
  headerTableViewCell.locationLabel.text = lastLocation;
  
  headerTableViewCell.timeLabel.text = [self.responceData timeLabelTextForPhotoAtIndex:section];
  
  if (![avatarURL isEqual:[NSNull null]]) {
     headerTableViewCell.avatarImage.imageURL = [NSURL URLWithString: avatarURL];
  }
 
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personHeaderViewWasTapped:)];
  [headerTableViewCell addGestureRecognizer:tapRecognizer];
  [tapRecognizer release];
  return headerTableViewCell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *arrayOfPhotos = [self.responceData photos];
  id photo = [arrayOfPhotos objectAtIndex:indexPath.section];
  NSString *caption = [photo objectForKey:@"caption"];

  NSString *uuid = [photo objectForKey:@"uuid"];
  NSString *twitter_avatar_url = [photo objectForKey:@"twitter_avatar_url"];
 
  NSUInteger likeCount = [[photo objectForKey:@"likes_count"] intValue];
  NSUInteger bouncesCount = [[photo objectForKey:@"bounces_count"] intValue];
  NSUInteger commentsCount = [[photo objectForKey:@"comments_count"] intValue];
  NSUInteger taggedPeopleCount = [[photo objectForKey:@"tagged_people_count"] intValue];
  NSUInteger tagsCount = [[photo objectForKey:@"tags_count"] intValue];
  
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
   
   _cell.photoImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://s3.amazonaws.com/com.clixtr.picbounce/photos/%@/big.jpg",uuid]];

   _cell.bounceCountLabel.text = [NSString stringWithFormat:@"%d",bouncesCount];
   _cell.commentCountLabel.text = [NSString stringWithFormat:@"%d",commentsCount];
  _cell.likeCountLabel.text = [NSString stringWithFormat:@"%d",likeCount];
  _cell.personCountLabel.text = [NSString stringWithFormat:@"%d",taggedPeopleCount];
  _cell.hashTagCountLabel.text = [NSString stringWithFormat:@"%d",tagsCount];
  
  
   if (![caption isEqual:[NSNull null]])
   _cell.commentLabel.text = caption;
   else
   _cell.commentLabel.text = @"";
  return cell;
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




#pragma mark Buttons and Gesture Recoginizers


-(IBAction) commentButtonPressed:(UIButton *) sender {
  PBCommentListViewController *vc = [[PBCommentListViewController alloc] initWithNibName:@"PBCommentListViewController" bundle:nil];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}


-(void) personHeaderViewWasTapped:(UITapGestureRecognizer *)sender {

}


-(IBAction) photosButtonPressed {
  if (([self numberOfSectionsInTableView:self.tableView] > 1)) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
}

-(IBAction) followingButtonPressed { 
  NSURL *followingURL = [self.responceData followingURL];
  if (followingURL) {
   // PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
    //vc.url = followingURL;
   // [self.navigationController pushViewController:vc animated:YES];
   // [vc release]; 
  }
}

-(IBAction) followersButtonPressed {
  //NSURL *followersURL = [responseData followersURL];
  //if (followersURL) {
   // PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
    //vc.url = followersURL;
    //[self.navigationController pushViewController:vc animated:YES];
    //[vc release]; 
  //}  
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


//Follow 
-(IBAction) followButtonPressed:(UIButton *) sender {
 
  
  ASIFormDataRequest *followRequest = [ASIFormDataRequest requestWithURL:[self.responceData followUserURLForUser]];
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
  [loginViewController release];
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
