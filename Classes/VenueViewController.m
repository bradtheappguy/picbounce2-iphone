//
//  VenueViewController.m
//  PathBoxes
//
//  Created by BradSmith on 2/19/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "VenueViewController.h"
#import "MyTableViewCell.h"
#import "ASIDownloadCache.h"
#import "MyTableViewController.h"

@implementation VenueViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor colorWithRed:0.945 green:0.933 blue:0.941 alpha:1.0];
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.tableView.separatorColor = [UIColor clearColor];
  
  
  self.url = [NSURL URLWithString:@"https://api.foursquare.com/v1/venues.json?geolat=40&geolong=-73&l=10"];
  [self loadFromCache];
}

-(void) loadFromCache {
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.url
                                                usingCache:[ASIDownloadCache sharedCache]
                                            andCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
  [request setUsername:@"4152386496"];
  [request setPassword:@"poopypants"];
  
  [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(doneLoadingTableViewDataFromNetwork:)];
  [request startAsynchronous];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  if (showProfileHeader) {
    return 2;
  } 
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (showProfileHeader) {
    if (section == 0) {
      return 1;
    }
    else {
      return [data count];
    }
    
  } 
  NSUInteger arr = [[[[[data objectAtIndex:0] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"venues"] count];

  return arr;
}


-(UITableViewCell *) profileHeaderTableViewCell {
  static NSString *MyIdentifier = @"HEADER";
  
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"HeaderTableViewCell" owner:self options:nil];
    cell = headerCell;
    self.headerCell = nil;
  }
  UILabel *label;
  label = (UILabel *)[cell viewWithTag:1];
  //label.text = [NSString stringWithFormat:@"%d", indexPath.row];
  
  label = (UILabel *)[cell viewWithTag:2];
  //label.text = [NSString stringWithFormat:@"%d", NUMBER_OF_ROWS - indexPath.row];
  
  return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
  if (showProfileHeader && indexPath.section == 0) {
    return [self profileHeaderTableViewCell];
  }
  
  
  static NSString *CellIdentifier = @"Cell";
  
  MyTableViewCell *cell = nil;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    cell.tableView = self.tableView;
  }
  
  // Configure the cell...
  cell.datum = [[[[[data objectAtIndex:0] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"venues"] objectAtIndex:indexPath.row];
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView beginUpdates];
  [self.tableView endUpdates];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 25; 
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (showProfileHeader && section == 0) {
    return nil; 
  }
  
  UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 25)];
  
  headerView.image = [UIImage imageNamed:@"bg_section_header.png"];
  headerView.backgroundColor = [UIColor clearColor];
  return headerView;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [super dealloc];
}


- (void)doneLoadingTableViewDataFromNetwork:(ASIHTTPRequest *) request {
	NSString *json_string = request.responseString;
  NSLog(json_string);
	NSArray *array = [[[SBJSON alloc] init] objectWithString:json_string error:nil];
  
  if ([array isKindOfClass:[NSArray class]]) {
    data = [array retain];
  }
  if ([array isKindOfClass:[NSDictionary class]]) {
    data = [[NSArray alloc] initWithObjects:array,nil];
  }
  
	/*
   NSString *status_code = @"500";
   for (NSDictionary *status in statuses)
   {
   if ([status objectForKey:@"status_code"]){
   status_code = [status objectForKey:@"status_code"];
   
   }
   }
   */
  
  
  [self.tableView reloadData];
  
	[self dataSourceDidFinishLoadingNewData];
}

-(void) avatarButtonPressed:(id) sender {
  MyTableViewController *tvc = [[MyTableViewController alloc] initWithNibName:@"MyTableViewController" bundle:nil];
  tvc.showProfileHeader = YES;
  
  [self.navigationController pushViewController:tvc animated:YES];
  [tvc release];
  
}
@end

