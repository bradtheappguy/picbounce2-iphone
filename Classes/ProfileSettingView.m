//
//  ProfileSettingView.m
//  PicBounce2
//
//  Created by Nitin on 4/19/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "ProfileSettingView.h"
#import "ProfileAboutView.h"
#import "AccountSettingView.h"


@implementation ProfileSettingView

@synthesize toggle;

- (id)initWithStyle:(UITableViewStyle)style
{
    //self = [super initWithStyle:style];
    
    //self = [super initWithStyle:UITableViewStyleGrouped];

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [array1 release];
    [array2 release];
    [array3 release];
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
    
    toggle = [[[UISwitch alloc]initWithFrame:CGRectMake(200, 8, 70,30 )]autorelease];
    
    mytable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,320, 415) style:UITableViewStyleGrouped];
    
    mytable.userInteractionEnabled = YES;
    mytable.delegate = self;
    mytable.dataSource = self;
    
    self.navigationItem.leftBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@" Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)]autorelease];


    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"About"style:UIBarButtonItemStyleBordered target:self action:@selector(about)] autorelease];
    
    [self.view addSubview:mytable];
    
    self.title = @"Settings";
    
     array1	= [[NSArray arrayWithObjects:@"Find Friends", @"Invite Friends", @"Search", nil] retain];
    array2 =[[NSArray arrayWithObjects:@"Edit Profile",@"Share Account",@"Change Profile Pic",@"Log Out", nil]retain] ;
    array3 = [[NSArray arrayWithObjects:@"Photos are Private", nil]retain];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //self.tableView.style = UITableViewStyleGrouped;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)back{

    [self dismissModalViewControllerAnimated:YES];

}
-(void)about{
    
    ProfileAboutView *about = [[[ProfileAboutView alloc]initWithNibName:nil bundle:nil]autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:about] autorelease];
    
    [self presentModalViewController:navController animated:YES];
    


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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(section == 0){
        return [array1 count];
    }
    else if(section == 1){
    
        return [array2 count];
    }
    else{
    
        return [array3 count ];
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
        
    
    if (indexPath.section == 0) {
       
        cell.textLabel.text = [array1 objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        
    
    
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = [array2 objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0 |indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }
    else if(indexPath.section == 2){
        cell.textLabel.text = [array3 objectAtIndex:indexPath.row];
        [cell.contentView addSubview:toggle];
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
   
    if (indexPath.section == 1 ) {
        if (indexPath.row == 1) {
            AccountSettingView *account = [[[AccountSettingView alloc]init]autorelease];
            [self .navigationController pushViewController:account animated:YES];
            
        }
        
       
        
            }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
