//
//  ProfileAboutView.m
//  PicBounce2
//
//  Created by Nitin on 4/19/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "ProfileAboutView.h"
#import "AboutWebView.h"



@implementation ProfileAboutView

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
    [array4 release];
    [array5 release];
    
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
    
    self.title = NSLocalizedString(@"About",nil);
    
    aboutTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,320, 415) style:UITableViewStyleGrouped];
    aboutTable.userInteractionEnabled = YES;
    aboutTable.delegate = self;
    aboutTable.dataSource = self;
    
    [self.view addSubview:aboutTable];

    array4	= [[NSArray arrayWithObjects:NSLocalizedString(@"Send Feedback",nil), NSLocalizedString(@"Contact Support",nil), NSLocalizedString(@"Rate PicBounce in App Store",nil), nil] retain];
   
    array5 =[[NSArray arrayWithObjects:NSLocalizedString(@"PicBounce Web",nil),NSLocalizedString(@"Terms of Use",nil),NSLocalizedString(@"Privacy Policy",nil), nil]retain] ;
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done",nil)style:UIBarButtonItemStyleBordered target:self action:@selector(Done)] autorelease];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)Done{

    [self dismissModalViewControllerAnimated:YES];
    
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return [array4 count];
    }  
    else  {
        return [array5 count];
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
        cell.textLabel.text = [array4 objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = [array5 objectAtIndex:indexPath.row];
        
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
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.section == 0) { //check the section
        
        if (indexPath.row == 0  ) {  //check the row no.
            
            
               
                        
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            
           
            [controller setToRecipients:[NSArray arrayWithObject:@"feedback@clixtr.com"]];
            
            
            [self presentModalViewController:controller animated:YES];
            [controller release];
            
        
                        
            
        } 
                
       
            else if (indexPath.row == 1) {
                
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                            
                [controller setToRecipients:[NSArray arrayWithObject:@"support@clixtr.com"]];
            
                
                [self presentModalViewController:controller animated:YES];
                [controller release];    
        
        
      }
       else if (indexPath.row ==2 ) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=378022697&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
        }

    } 
 
    ///////////////////////////////////////////////////////////////////////
    
    else if(indexPath.section == 1){
    
        if (indexPath.row == 0) {
            AboutWebView *webview = [[[AboutWebView alloc]initWithNibName:nil bundle:nil]autorelease];
            webview.link = 1; ///assign flag to compare and do activity
            [self.navigationController pushViewController:webview animated:YES];
            
        }
        else if(indexPath.row == 1){
            AboutWebView *webview = [[[AboutWebView alloc]initWithNibName:nil bundle:nil]autorelease];
            webview.link = 2; ////assign flag to compare and do activity
            [self.navigationController pushViewController:webview animated:YES];

        
        }
        else if(indexPath.row == 2){
            AboutWebView *webview = [[[AboutWebView alloc]initWithNibName:nil bundle:nil]autorelease];
            webview.link = 3; ////assign flag to compare and do activity
            [self.navigationController pushViewController:webview animated:YES];
            
            
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
