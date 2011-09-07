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



@implementation PBPersonListViewController
@synthesize showiPhoneContacts = _showiPhoneContacts;

#pragma mark -
#pragma mark View lifecycle


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [namelist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 52;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"PersonCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"PBPersonTableViewCell" owner:self options:nil];
    cell = _cell;
    _cell = nil;
  }
  
  NSDictionary *person = [namelist objectAtIndex:indexPath.row];
   cell.textLabel.text = [self.responceData usernameForPersonAtIndex:indexPath.row];
   cell.detailTextLabel.text = @"Lady Gaga";
   cell.imageView.image = [UIImage imageNamed:@"btn_smiley.png"];
   
   EGOImageView *avatarImage = [[EGOImageView alloc] initWithFrame:CGRectMake(7, 52/2-40/2, 40, 40)];
   
   avatarImage.imageURL = [NSURL URLWithString:@"http://a0.twimg.com/profile_images/1236631904/DSC07560_-_C_pia_-_C_pia_normal.JPG"];
   [cell.contentView addSubview:avatarImage];
   [avatarImage release];
   
   UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   button.frame = CGRectMake(243, 52/2-24/2, 70, 24);
   
   //UIImage *bg = [[UIImage imageNamed:@"bg_green_btn.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
   
   [button setBackgroundImage:[UIImage imageNamed:@"greenButton.png"] forState:UIControlStateNormal];
   [button setTitle:@"Follow" forState:UIControlStateNormal];
   [button addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
   [cell.contentView addSubview:button];
   
      
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //TODO
  
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
  namelist = [self.responceData people];
  [self.tableView reloadData];
}

@end

