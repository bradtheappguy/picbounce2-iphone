//
//  PBProfileViewController.m
//
//  Created by BradSmith on 2/21/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_PADDING 15


@implementation PBProfileViewController

@synthesize shouldShowProfileHeader;
@synthesize shouldShowProfileHeaderBeforeNetworkLoad;
@synthesize shouldShowFollowingBar;
@synthesize segmentedControl;

@synthesize preloadedAvatarURL;
@synthesize preloadedLocation;
@synthesize preloadedName;


#pragma mark View LifeCycle
- (void) viewDidLoad {
  [super viewDidLoad];
  if (!self.url) {
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/popular",API_BASE]];
  }
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_grey.png"]];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.tableView.backgroundView addSubview:[self headerForAboveTableView:self.tableView]]; 
  self.tableView.tableFooterView = [self footerViewForTable:self.tableView];
}


- (void) viewWillAppear:(BOOL)animated {
  if ([data count] < 1) {
    [self enterReloadMode];
    
  }  
} 


#pragma mark Table View Layout and Sizes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  if ([data count] > 0) {
    return [data count] + 1;
  }
  else {
    if (shouldShowProfileHeaderBeforeNetworkLoad) {
      return 1;
    }
    return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 25; 
} 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
  if (indexPath.section == 0) {
    if (shouldShowProfileHeader) {
      return 148;
    }
    else {
      return 35;
    }
  }
  return [PhotoCell height] + CELL_PADDING;
  
}

#pragma mark Cells and Headers
- (UIImageView *) headerForAboveTableView:(UITableView *)tableView {
  UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
  header.image = [UIImage imageNamed:@"bg_grey.png"];
  header.backgroundColor = [UIColor blueColor];
  return [header autorelease];
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
  [[NSBundle mainBundle] loadNibNamed:@"HeaderTableViewCell" owner:self options:nil];
  
  NSArray *arrayOfPhotos;
  
  if ([[data class] isSubclassOfClass:[NSArray class]]) {
    arrayOfPhotos = data;
  }
  else {
    arrayOfPhotos = [data objectForKey:@"photos"];
  }

  
  
  
  id x;
  if ([arrayOfPhotos count] >= section) {
    x = [arrayOfPhotos objectAtIndex:section-1];
  }
  
  id y = [x objectForKey:@"photo"];
  // NSString *caption = [y objectForKey:@"caption"];
  // NSString *viewCount = [y objectForKey:@"view_count"];
  // NSString *uuid = [y objectForKey:@"uuid"];
  NSString *name = [y objectForKey:@"twitter_screen_name"];
  NSString *avatarURL = [y objectForKey:@"twitter_avatar_url"];
  
  headerTableViewCell.nameLabel.text = name;
  headerTableViewCell.locationLabel.text = @"New Work City, NYC";
  headerTableViewCell.timeLabel.text = @"1h";
  if (![avatarURL isEqual:[NSNull null]]) {
     headerTableViewCell.avatarImage.imageURL = [NSURL URLWithString: avatarURL];
  }
 
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personHeaderViewWasTapped:)];
  [headerTableViewCell addGestureRecognizer:tapRecognizer];
  [tapRecognizer release];
  return headerTableViewCell;
}

- (UITableViewCell *)profileHeaderCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSDictionary *userData;
  if ([[data class] isSubclassOfClass:[NSArray class]]) {
    userData = nil;
  }
  else if ([[data class] isSubclassOfClass:[NSDictionary class]]){
    userData = [(NSDictionary*) data objectForKey:@"user"];
   // id badges_count = [userData objectForKey:"badges_count"];
  }

  
  
  
  static NSString *MyIdentifier = @"CELL";
  
  ProfileHeaderCell *_cell = (ProfileHeaderCell *) [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (_cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderCell" owner:self options:nil];
    _cell = cell;
    // self.tvCell = nil;
  }
  
  UITapGestureRecognizer *tapRecoginizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfilePhotoButtonPressed:)];
  [_cell.avatarIcon addGestureRecognizer:tapRecoginizer];
  
  profileAvatarImageView = _cell.avatarIcon;
//  if (shouldShowProfileHeaderBeforeNetworkLoad && ([data count] < 1)) {
  if (preloadedName) {
    _cell.followersCountLabel.text = @"";
    _cell.badgesCountLabel.text = @"";
    _cell.followingCountLabel.text = @"";
    _cell.photosCountLabel.text = @"";
    _cell.nameLabel.text = preloadedName;
    _cell.locationLabel.text = preloadedLocation;
    _cell.avatarIcon.imageURL = preloadedAvatarURL;
  }
  else {
    _cell.followersCountLabel.text = @"1";
    _cell.badgesCountLabel.text = @"1";
    _cell.followingCountLabel.text = @"1";
    _cell.photosCountLabel.text = @"1";
    _cell.nameLabel.text = @"Lessfame";
    _cell.locationLabel.text = @"LowerEastSide";
    _cell.avatarIcon.imageURL = [NSURL URLWithString: @"http://a2.twimg.com/profile_images/1225485762/image_normal.jpg"];
  }  
  return _cell;
}

- (UITableViewCell *)photoHeaderCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *arrayOfPhotos;
  if ([[data class] isSubclassOfClass:[NSArray class]]) {
    arrayOfPhotos = data;
  }
  else {
    arrayOfPhotos = [data objectForKey:@"photos"];
  }
  
  
  id x = nil;
  if (indexPath.section > 0) {
    x = [arrayOfPhotos objectAtIndex:(indexPath.section)-1];
  }
  id y = [x objectForKey:@"photo"];
  NSString *caption = [y objectForKey:@"caption"];
  NSString *viewCount = [y objectForKey:@"view_count"];
  NSString *uuid = [y objectForKey:@"uuid"];
  //NSString *name = [y objectForKey:@"twitter_screen_name"];
  
  static NSString *MyIdentifier = @"CELL";
  
  PhotoCell *_cell = (PhotoCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (_cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
    _cell = cell;
    // self.tvCell = nil;
  }
  
  _cell.tableViewController = self;
  _cell.avatarImageView.imageURL = [NSURL URLWithString:@"http://a0.twimg.com/profile_images/1239447061/Unnamed-1_reasonably_small.jpg"];
  
  _cell.photoImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://s3.amazonaws.com/com.clixtr.picbounce/photos/%@/big.jpg",uuid]];
  _cell.viewCountLabel.text = [NSString stringWithFormat:@"Views: %@",viewCount];
  _cell.bounceCountLabel.text = [NSString stringWithFormat:@"%d",19];
  _cell.commentCountLabel.text = [NSString stringWithFormat:@"Comments: %d",3000];
  if (![caption isEqual:[NSNull null]])
    _cell.commentLabel.text = caption;
  return cell;  
}

- (UITableViewCell *)infoHeaderCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  [[NSBundle mainBundle] loadNibNamed:@"TableTitleTableViewCell" owner:self options:nil];
  tableTitleTableViewCell.textLabel.text = @"Following 1337 People";
  return tableTitleTableViewCell;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (shouldShowProfileHeader) {
      return [self profileHeaderCellForRowAtIndexPath:indexPath];
    }
    else {
      return [self infoHeaderCellForRowAtIndexPath:indexPath];
    }
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
  return YES;  
}

-(void) loadMoreData {
  footerDecoration.hidden = YES;
  [loadingMoreActivityIndicatiorView startAnimating];
  [self performSelector:@selector(moreDataDidLoad) withObject:nil afterDelay:4.0];
}

-(void) moreDataDidLoad {
  [loadingMoreActivityIndicatiorView stopAnimating];
  footerDecoration.hidden = NO;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self moreDataAvailable] && ([data count] > 0)) {
    if (indexPath.section == [self numberOfSectionsInTableView:tableView] - 1) {
      if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        [self loadMoreData];
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
  HeaderTableViewCell *view = (HeaderTableViewCell *)sender.view;
  
  PBProfileViewController *new = [[PBProfileViewController alloc] init];
  new.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/users/b2test/profile",API_BASE]];
  
  
  new.shouldShowProfileHeaderBeforeNetworkLoad = YES;
  new.shouldShowProfileHeader = YES;
  new.preloadedLocation = view.locationLabel.text;
  new.preloadedName = view.nameLabel.text;
  new.preloadedAvatarURL = view.avatarImage.imageURL;
  [self.navigationController pushViewController:new animated:YES];
  [new release];
}

-(IBAction) photosButtonPressed {
  if (([self numberOfSectionsInTableView:self.tableView] > 1)) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
}

-(IBAction) followingButtonPressed { 
  PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];  
}

-(IBAction) followersButtonPressed {
  PBPersonListViewController *vc = [[PBPersonListViewController alloc] initWithNibName:@"PBPersonListViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];  
}

-(IBAction) badgesButtonPressed {
  PBBadgeCollectionViewController *vc = [[PBBadgeCollectionViewController alloc] initWithNibName:@"PBBadgeCollectionViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}

-(IBAction) followButtonPressed:(UIButton *) sender {
  [sender setTitle:@"Following" forState:UIControlStateNormal];
}

-(IBAction) bounceButtonPressed:(id) sender {
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
