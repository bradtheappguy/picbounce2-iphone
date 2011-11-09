//
//  PBSharingOptionViewController.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBSharingOptionViewController.h"
#import "PBSharingOptionCell.h"
#import "PBCheckbox.h"
#import "FacebookSingleton.h"
#import "AppDelegate.h"
#import "PBSharedUser.h"
#import <QuartzCore/QuartzCore.h>


#define kIndent 40
#define kOffset(val) 10

@implementation PBSharingOptionViewController

@synthesize tableView;
@synthesize progressHUD;
@synthesize facebookPages;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
          // Custom initialization
  }
  self.title = @"Sharing";
  return self;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
  
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  
  [tableView release];
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {

  [super viewDidLoad];
  PBProgressHUD *hud =  [[PBProgressHUD alloc] initWithView:self.view];
  hud.labelText = @"Loading...";
  self.progressHUD = hud;
  [hud release];

  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.separatorColor = [UIColor lightGrayColor];
  [tableView reloadData];
  [tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sharing_settings.png"]]];
  [self.view addSubview:self.progressHUD];
}

- (void)viewDidUnload {
  
  [super viewDidUnload];
  self.tableView = nil;
}

-(void) viewDidAppear:(BOOL)animated {

  if ([[FacebookSingleton sharedFacebook] isSessionValid] ) {
    [self loadPagesFromFacebook];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [PBSharedUser setFacebookPages:self.facebookPages];
}

- (void) loadPagesFromFacebook {
  
  NSString *path = @"/fql?q=select%20page_id,%20type,%20name,%20page_url,pic_small%20from%20page%20where%20page_id%20in%20(%20select%20page_id,type%20from%20page_admin%20where%20uid=me()%20and%20type!%3d'APPLICATION')";
  
  path = @"/me/accounts";
  
  [[FacebookSingleton sharedFacebook] requestWithGraphPath:path andDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger rows = 2;
  if ([[FacebookSingleton sharedFacebook] isSessionValid])
    rows++;

  if ([facebookPages count] > 0)
    rows += [facebookPages count];

  return rows;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 50;
}

    // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"MyMessageCell";
  PBSharingOptionCell *customCell = (PBSharingOptionCell *) [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (customCell == nil) {
      
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PBSharingOptionCell" owner:nil options:nil];
    
    for(id currentObject in topLevelObjects)
    {
      if([currentObject isKindOfClass:[UITableViewCell class]])
      {
        customCell = (PBSharingOptionCell *) currentObject;
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
        break;
      }
    }
  }

  if (indexPath.row == kTwitterLoginCell) {
      
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    customCell.statusButton.hidden = YES;

    [customCell.contentView setBackgroundColor:[UIColor colorWithRed:208.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f]];
    [customCell.titleLabel setText:@"Twitter"];
    [customCell.statusButton setTag:indexPath.row];
    [customCell.statusButton addTarget:self action:@selector(loginlogoutButton:) forControlEvents:UIControlEventTouchUpInside];
  } else if (indexPath.row == kFaceBookLoginCell) {
    customCell.nameLabel.hidden = YES;
    if ([[FacebookSingleton sharedFacebook] isSessionValid]) {
      [customCell.statusButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
    else {
      [customCell.statusButton setTitle:@"Login" forState:UIControlStateNormal];
    }
    [customCell.contentView setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
    [customCell.titleLabel setText:@"Facebook"];
    [customCell.statusButton setTag:indexPath.row];
    [customCell.statusButton addTarget:self action:@selector(loginlogoutButton:) forControlEvents:UIControlEventTouchUpInside];
  } else if (indexPath.row >= kFacebookPagesCell) {

    [customCell.statusButton setHidden:YES];
    if (indexPath.row == 3) {
      [customCell.titleLabel setText:@"  Pages"];  
    }else {
      [customCell.titleLabel setText:@""];
    }

    PBCheckbox *checkbox = [[PBCheckbox alloc] initWithPosition:CGPointMake(kIndent, kOffset(5)) withFontName:@"HelveticaNeue" withFontSize:12];
    [checkbox setText:[[facebookPages objectAtIndex:indexPath.row-3] valueForKey:@"name"]];
    [checkbox setTag:indexPath.row-3];
    if ([[facebookPages objectAtIndex:indexPath.row-3] valueForKey:@"Selected"] == nil) {
      [[facebookPages objectAtIndex:indexPath.row-3] setObject:@"0" forKey:@"Selected"];
      checkbox.selected = NO;
    } else {
      if ([[[facebookPages objectAtIndex:indexPath.row-3] valueForKey:@"Selected"] isEqualToString:@"1"]) {
        checkbox.selected = YES;
      } else if ([[[facebookPages objectAtIndex:indexPath.row-3] valueForKey:@"Selected"] isEqualToString:@"0"]) {
        checkbox.selected = NO;
      }
    }
    customCell.nameLabel.hidden = YES;
    [checkbox addTarget:self action:@selector(fbPageTouched:) forControlEvents:UIControlEventTouchUpInside];
    [customCell.contentView addSubview:checkbox];
    [checkbox release];
  } else if (indexPath.row == kFacebookWallCell) {

    [customCell.statusButton setHidden:YES];
    [customCell.titleLabel setText:@"  My Wall"];  
    customCell.nameLabel.hidden = YES;
    
    PBCheckbox *checkbox = [[PBCheckbox alloc] initWithPosition:CGPointMake(kIndent, kOffset(5)) withFontName:@"HelveticaNeue" withFontSize:12];
    [checkbox setTag:indexPath.row];
    [checkbox setText:@"Brad Smith"];
    BOOL sel = [PBSharedUser shouldCrosspostToFBWall];
    checkbox.selected = sel;

    [checkbox addTarget:self action:@selector(fbWallTouched:) forControlEvents:UIControlEventTouchUpInside];
    [customCell.contentView addSubview:checkbox];
    [checkbox release];
  }

  return customCell;
}

- (void)fbPageTouched:(UIButton *)sender {
  
  int i = [[[facebookPages objectAtIndex:sender.tag] valueForKey:@"Selected"] intValue];
  i = !i;
  [[facebookPages objectAtIndex:sender.tag] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"Selected"];
}

- (void)fbWallTouched:(UIButton *)sender {
  [PBSharedUser setShouldCrosspostToFBWall:sender.selected];
}

- (void)loginlogoutButton:(UIButton *)sender {
  
  if (sender.tag == 1) {
      isTwitterLogut = NO;
      Facebook *facebook = [FacebookSingleton sharedFacebook];
      if ([facebook isSessionValid]) {
        [facebook logout:self];
        facebook.accessToken = nil;
        facebook.expirationDate = nil;
        facebook = nil;
        [facebookPages removeAllObjects];
        [sender setTitle:@"Login" forState:UIControlStateNormal];
        [tableView reloadData];
      } 
      else {
        [facebook authorize:[NSArray arrayWithObject: @"publish_stream,offline_access,manage_pages"] delegate:self];
        currStatusButtons = sender;
      }
    } else if (sender.tag == 0) {
      isTwitterLogut = YES;
      AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
      if ([appDelegate authToken] == nil) {
      [appDelegate setCurrentController:self];
      [appDelegate setUsingCameraView:YES];
      PBLoginViewController *loginViewController = [[PBLoginViewController alloc] initWithNibName:@"PBLoginViewController" bundle:nil];
      [self presentModalViewController:loginViewController animated:YES];
      [loginViewController release];
      [sender setTitle:@"Logout" forState:UIControlStateNormal];
    }else {
      appDelegate.authToken = nil;
      [sender setTitle:@"Login" forState:UIControlStateNormal];
    }
  }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark Facebook Delegate

- (void)fbDidLogin {
  
  [currStatusButtons setTitle:@"Logout" forState:UIControlStateNormal];
  [PBSharedUser setFacebookAccessToken:[[FacebookSingleton sharedFacebook] accessToken]];
  [PBSharedUser setFacebookExpirationDate:[[FacebookSingleton sharedFacebook] expirationDate]];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self loadPagesFromFacebook];
  [PBSharedUser setShouldCrosspostToFBWall:YES];
}


- (void)fbDidNotLogin:(BOOL)cancelled {

  [currStatusButtons setTitle:@"Login" forState:UIControlStateNormal];
}


- (void)fbDidLogout {
  
  [PBSharedUser removeFacebookAccessToken];
  [PBSharedUser removeFacebookExpirationDate];
  // Nil out the session variables to prevent
  // the app from thinking there is a valid session
  Facebook *facebook = [FacebookSingleton sharedFacebook];
  if ([facebook accessToken] != nil) {
    facebook.accessToken = nil;
  }
  if ([facebook expirationDate] != nil) {
    facebook.expirationDate = nil;
  }
}

- (void)requestLoading:(FBRequest *)request {
  
    [self.progressHUD showUsingAnimation:YES];
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
  
  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
  int responseStatusCode = [httpResponse statusCode];
  if (responseStatusCode == 200) {

  }
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
  NSString *errorDescription = [[[error userInfo] objectForKey:@"error"] objectForKey:@"message"];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert release];
  [self.progressHUD hide:YES];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
  [self.progressHUD hide:YES];
  
  
  NSMutableArray *pagesFromFacebook  = [[result objectForKey:@"data"] mutableCopy];
  NSArray *lastSAvedPages = [PBSharedUser facebookPages];
  
  for (NSDictionary *page in pagesFromFacebook) {
    for (NSDictionary *lastSavedPAge in lastSAvedPages) {
      if ([[page objectForKey:@"id"] isEqualToString: [lastSavedPAge objectForKey:@"id"]]) {
        [page setValue:[lastSavedPAge objectForKey:@"Selected"] forKey:@"Selected"];
      }
    }
  }
  
  self.facebookPages = pagesFromFacebook;
  [tableView reloadData];
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data {
    
}

@end
