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


#pragma mark -
#pragma mark View lifecycle


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSUInteger num = [responceData numberOfPeople];
  return num;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
  UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
  image.backgroundColor = [UIColor lightGrayColor];
  image.layer.cornerRadius = 4;
  cell.textLabel.text = [responceData usernameForPersonAtIndex:indexPath.row];
  cell.detailTextLabel.text = @"Lady Gaga";
  cell.imageView.image = [UIImage imageNamed:@"btn_smiley.png"];
  EGOImageView *avatarImage = [[EGOImageView alloc] initWithFrame:CGRectMake(1, 1, 40, 40)];
  
  avatarImage.imageURL = [NSURL URLWithString:@"http://a0.twimg.com/profile_images/1236631904/DSC07560_-_C_pia_-_C_pia_normal.JPG"];
  [cell.contentView addSubview:avatarImage];
  [avatarImage release];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  button.frame = CGRectMake(240, 5, 75, 30);
  [button setTitle:@"Follow" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [cell.contentView addSubview:button];
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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

@end

