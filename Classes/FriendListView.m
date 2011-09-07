//
//  FriendListView.m
//  PicBounce2
//
//  Created by Sunil on 5/2/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "FriendListView.h"
#import "PBPersonListViewController.h"


@implementation FriendListView

- (id)initWithStyle:(UITableViewStyle)style
{
    //self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
    return self;
}

- (void)dealloc
{
    [Contactlist release];
    [Suggestlist release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    frendlistTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,320, 415) style:UITableViewStyleGrouped];
    
    frendlistTable.userInteractionEnabled = YES;
    frendlistTable.delegate = self;
    frendlistTable.dataSource = self;

    
    [self.view addSubview:frendlistTable];
    
   self.title = NSLocalizedString(@"Friends List",nil);
    
    
    Contactlist	= [[NSArray arrayWithObjects:
                NSLocalizedString (@"From my contact list",nil),
                NSLocalizedString(@"Facebook friends",nil),
                NSLocalizedString( @"Twitter Friends",nil),
                NSLocalizedString( @"Search names and usernames",nil), nil]
                retain];
    
    Suggestlist = [[NSArray arrayWithObjects:
                  NSLocalizedString(@"Suggest users ",nil), nil]
                  retain];
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(section == 0){
        return [Contactlist count];
    }
    else {
    
        return [Suggestlist count];
    
    } 
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [Contactlist objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1){
    
        cell.textLabel.text = [Suggestlist objectAtIndex:indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            PBPersonListViewController *personlist = [[[PBPersonListViewController alloc]initWithNibName:@"PBPersonListViewController" bundle:nil]autorelease];
            personlist.showiPhoneContacts = 1;
            
            [self.navigationController pushViewController:personlist animated:YES];
            
        }
        
         if (indexPath.row == 1) {
            
            PBPersonListViewController *personlist = [[[PBPersonListViewController alloc]initWithNibName:@"PBPersonListViewController" bundle:nil]autorelease];
            
            [self.navigationController pushViewController:personlist animated:YES];
            
        }
        if (indexPath.row == 2) {
            
            PBPersonListViewController *personlist = [[[PBPersonListViewController alloc]initWithNibName:@"PBPersonListViewController" bundle:nil]autorelease];
            
            [self.navigationController pushViewController:personlist animated:YES];
            
        }
    
    
    }
 
    
    
}

@end
