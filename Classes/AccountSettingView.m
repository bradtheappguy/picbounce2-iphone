//
//  AccountSettingView.m
//  PicBounce2
//
//  Created by Nitin on 4/20/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "AccountSettingView.h"


@implementation AccountSettingView
@synthesize fbbutton;


- (id)initWithStyle:(UITableViewStyle)style
{
    //self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
    [array6 release];
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
        	
    
    self.title =NSLocalizedString( @"Account Settings",nil);
    
    array6	= [[NSArray arrayWithObjects:NSLocalizedString(@"Facebook",nil), NSLocalizedString(@"Twitter",nil),NSLocalizedString( @"Flicker",nil ),NSLocalizedString(@"Tumbler",nil),NSLocalizedString(@"Posterous",nil),NSLocalizedString(@"MySpace",nil), nil] retain];    
    
    accountTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415) style:UITableViewStyleGrouped]autorelease];
    accountTable.dataSource = self;
    accountTable.delegate = self;
    accountTable.userInteractionEnabled = YES;
     
    [self.view addSubview:accountTable];
    
    
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

-(IBAction)facebooklogin:(id)sender {
    
    UIImage *deselected = [UIImage imageNamed:@"login.png"];
    UIImage *selected = [UIImage imageNamed:@"logout.png"];
    
    
    if ([sender isSelected]) {
        [sender setImage:deselected forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    
    else {
        [sender setImage:selected forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [array6 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0 ) {
        
        cell.textLabel.text = [array6 objectAtIndex:indexPath.row];
        
        
        if (indexPath.row == 0) {  ////set the button for facebbok
            
                       
            fbview = [[[UIView alloc]initWithFrame:CGRectMake(200, 6, 80,30)]autorelease];
            //fbview.backgroundColor = [UIColor redColor];
            
            fbbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            fbbutton.frame = CGRectMake(0, 0, 80,30);
            [fbbutton addTarget:self action:@selector(facebooklogin:) forControlEvents:UIControlEventTouchUpInside];
            
            [fbbutton setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
            
            [fbview addSubview:fbbutton];

           [cell.contentView addSubview:fbview]; 
           
            //
        
      }
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
