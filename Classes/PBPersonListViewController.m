//
//  PBPersonListViewController.m
//  PicBounce2
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBPersonListViewController.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "PBPersonTableViewCell.h"

@implementation PBPersonListViewController
@synthesize showiPhoneContacts = _showiPhoneContacts;

#pragma mark -
#pragma mark View lifecycle


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [namelist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 51;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"PersonCell";
  
  PBPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"PBPersonTableViewCell" owner:self options:nil];
    cell = (PBPersonTableViewCell *)_cell;
    _cell = nil;
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.contentView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:248/255.0 green:237/255.0 blue:230/255.0 alpha:0.33] CGColor],
                       (id)[[UIColor colorWithRed:227/255.0 green:212/255.0 blue:199/255.0 alpha:0.33] CGColor], 
                       nil];
    [cell.contentView.layer insertSublayer:gradient atIndex:0];
  }
  
   cell.nameLabel.text = [self.responceData usernameForPersonAtIndex:indexPath.row];
   cell.screenNameLabel.text = @"Lady Gaga";
   cell.avatarImageView.imageURL = [NSURL URLWithString:@"http://a0.twimg.com/profile_images/1236631904/DSC07560_-_C_pia_-_C_pia_normal.JPG"];
        
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

-(void)populateNamesFromAddressBook{
  namelist = [[NSMutableArray alloc]init];
  emailList = [[NSMutableArray alloc]init];
  ABMutableMultiValueRef multiEmail;
  ABAddressBookRef addressBook = ABAddressBookCreate();
  CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
  CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
  NSString *name;
  NSString *homeEmail;
  for( int i = 0 ; i < nPeople ; i++ ) {
    ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i );
    multiEmail = ABRecordCopyValue(ref, kABPersonEmailProperty);
    name = (NSString *)ABRecordCopyCompositeName((ABRecordRef)ref);
    homeEmail =  (NSString *) ABMultiValueCopyValueAtIndex(multiEmail, 0);
    [namelist addObject:name];
    [emailList addObject:homeEmail];/// replace "homemail" by "email" to get multiple email             
    [homeEmail release];
    [name release];
    CFRelease(multiEmail);
  }
  CFRelease(addressBook);
  CFRelease(allPeople);
}

- (void)viewDidLoad {
  if (self.showiPhoneContacts) {
    [self populateNamesFromAddressBook];
  }
  [super viewDidLoad];
  UIImage *backgroundPattern = [UIImage imageNamed:@"bg_pattern"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.separatorColor = [UIColor colorWithRed:203/255.0 green:186/255.0 blue:174/255.0 alpha:1];
  UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
  [self.tableView setTableFooterView:footer];
  [footer release];
  searchBar.backgroundColor = [UIColor clearColor];
  for (UIView *view in searchBar.subviews) {
    if (![view isKindOfClass:[UITextField class]]) {
      view.alpha = 0;
    }
  }
  self.tableView.tableHeaderView = nil;
  
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self reloadTableViewDataSourceUsingCache:NO];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [super dealloc];
}

- (IBAction) followButtonPressed:(id) sender {
  
  
}

- (void) reload {
  namelist = (NSArray *) [self.responceData people];
  [self.tableView reloadData];
}

@end

