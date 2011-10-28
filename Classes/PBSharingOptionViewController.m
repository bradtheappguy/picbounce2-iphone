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
#import <QuartzCore/QuartzCore.h>


#define kIndent 40
#define kOffset(val) 10

@implementation PBSharingOptionViewController
@synthesize tableView;
@synthesize a_OptionArray;
@synthesize progressHUD = _progressHUD;
@synthesize facebookPages = _facebookPages;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    self.title = @"Sharing";
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    PBProgressHUD *hud =  [[PBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Loading...";
    self.progressHUD = hud;
    [hud release];
    
    tableView.layer.cornerRadius = 5.0f;
    tableView.layer.borderWidth = 0.7f;
    tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self makeSizeOfTable];
    
    [self.view addSubview:self.progressHUD];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClicked)];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
    
}


- (void)backBarButtonItemClicked {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_facebookPages count]; i++) {
        if ([[[_facebookPages objectAtIndex:i] valueForKey:@"Selected"] isEqualToString:@"1"]) {
            [array addObject:[_facebookPages objectAtIndex:i]]; 
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SelectedArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadPagesFromFacebook {
    NSString *path = @"/fql?q=select%20page_id,%20type,%20name,%20page_url,pic_small%20from%20page%20where%20page_id%20in%20(%20select%20page_id,type%20from%20page_admin%20where%20uid=me()%20and%20type!%3d'APPLICATION')";
    
    [ [FacebookSingleton sharedFacebook] requestWithGraphPath:path andDelegate:self];
}

-(void) viewDidAppear:(BOOL)animated {
    
    if ([[FacebookSingleton sharedFacebook] isSessionValid] ) {
        [self loadPagesFromFacebook];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 2:
            return 1;
            break;
            
        case 3:
            return [_facebookPages count];
            break;
        case 1:
            return 1;
            break;
            
            
            
        default:
            break;
    }
    return 10;//[a_OptionArray count];
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
        //NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[a_CommentsArray objectAtIndex:indexPath.row] valueForKey:@"item"]];
        //  dict = nil;
    
    
    if (indexPath.section == 0) {
        
        facebook = [FacebookSingleton sharedFacebook];
        if ([facebook isSessionValid]) {
            [customCell.a_StatusButton setTitle:@"Logout" forState:UIControlStateNormal];
        }
        else {
            [customCell.a_StatusButton setTitle:@"Login" forState:UIControlStateNormal];
        }
        [customCell.contentView setBackgroundColor:[UIColor colorWithRed:208.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f]];
        [customCell.a_TitleLabel setText:@"Facebook"];
        [customCell.a_StatusButton setTag:indexPath.section];
        [customCell.a_StatusButton addTarget:self action:@selector(loginlogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.section == 1) {
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        if ([appDelegate authToken] == nil) {
            [customCell.a_StatusButton setTitle:@"Login" forState:UIControlStateNormal];
        }else {
            [customCell.a_StatusButton setTitle:@"Logout" forState:UIControlStateNormal];  
        }
        [customCell.contentView setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
        [customCell.a_TitleLabel setText:@"Twitter"];
        [customCell.a_StatusButton setTag:indexPath.section];
        [customCell.a_StatusButton addTarget:self action:@selector(loginlogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.section == 3) {
        [customCell.a_StatusButton setHidden:YES];
        if (indexPath.row == 0) {
            [customCell.a_TitleLabel setText:@"  Pages"];  
        }else {
            [customCell.a_TitleLabel setText:@""];
        }
        
        
        PBCheckbox *EWCheckbox = [[PBCheckbox alloc] initWithPosition:CGPointMake(kIndent, kOffset(5))];
        [EWCheckbox setText:[[_facebookPages objectAtIndex:indexPath.row] valueForKey:@"name"]];
        [EWCheckbox setTag:indexPath.row];
        if ([[_facebookPages objectAtIndex:indexPath.row] valueForKey:@"Selected"] == nil) {
            [[_facebookPages objectAtIndex:indexPath.row] setObject:@"0" forKey:@"Selected"];
            EWCheckbox.selected = NO;
        }else 
            {
            if ([[[_facebookPages objectAtIndex:indexPath.row] valueForKey:@"Selected"] isEqualToString:@"1"]) {
                EWCheckbox.selected = YES;
            }
            else  if ([[[_facebookPages objectAtIndex:indexPath.row] valueForKey:@"Selected"] isEqualToString:@"0"]) {
                EWCheckbox.selected = NO;
            }
            }
            //[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
        [EWCheckbox addTarget:self action:@selector(ewTouched:) forControlEvents:UIControlEventTouchUpInside];
        [customCell.contentView addSubview:EWCheckbox];
        [EWCheckbox release];
    }else if (indexPath.section == 2) {
        [customCell.a_StatusButton setHidden:YES];
        if (indexPath.row == 0) {
            [customCell.a_TitleLabel setText:@"  Wall"];  
        }else {
            [customCell.a_TitleLabel setText:@""];
        }
        
        
        PBCheckbox *EWCheckbox = [[PBCheckbox alloc] initWithPosition:CGPointMake(kIndent, kOffset(5))];
        [EWCheckbox setText:@"Lady Gaga"];
        [EWCheckbox setTag:indexPath.row];
        if ([[_facebookPages objectAtIndex:indexPath.row] valueForKey:@"Selected"] == nil) {
            [[_facebookPages objectAtIndex:indexPath.row] setObject:@"0" forKey:@"Selected"];
            EWCheckbox.selected = NO;
        }else 
            {
            if ([[[_facebookPages objectAtIndex:indexPath.row] valueForKey:@"Selected"] isEqualToString:@"1"]) {
                EWCheckbox.selected = YES;
            }
            else  if ([[[_facebookPages objectAtIndex:indexPath.row] valueForKey:@"Selected"] isEqualToString:@"0"]) {
                EWCheckbox.selected = NO;
            }
            }
            //[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
        [EWCheckbox addTarget:self action:@selector(ewTouched:) forControlEvents:UIControlEventTouchUpInside];
        [customCell.contentView addSubview:EWCheckbox];
        [EWCheckbox release];
    }
    return customCell;
}
- (void)ewTouched:(UIButton *)sender {
    int i = [[[_facebookPages objectAtIndex:sender.tag] valueForKey:@"Selected"] intValue];
    i = !i;
    [[_facebookPages objectAtIndex:sender.tag] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"Selected"];
}
- (void)loginlogoutButton:(UIButton *)sender {
    if (sender.tag == 0) {
        isTwitterLogut = NO;
        
        if ([facebook isSessionValid]) {
            
            
            [facebook logout:self];
            facebook.accessToken = nil;
            facebook.expirationDate = nil;
            facebook = nil;
            [_facebookPages removeAllObjects];
            [sender setTitle:@"Login" forState:UIControlStateNormal];
        } 
        else {
            facebook = [FacebookSingleton sharedFacebook];
            [facebook authorize:[NSArray arrayWithObject: @"publish_stream,offline_access,manage_pages"] delegate:self];
            [sender setTitle:@"Logout" forState:UIControlStateNormal];
        }
    }else if (sender.tag == 1) {
        isTwitterLogut = YES;
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        if ([appDelegate authToken] == nil) {
            [appDelegate presentLoginViewController];
            [sender setTitle:@"Logout" forState:UIControlStateNormal];
        }else {
            appDelegate.authToken = nil;
            [sender setTitle:@"Login" forState:UIControlStateNormal];
        }
    }
    
}
#pragma Table view Height
- (void)makeSizeOfTable {
    NSInteger height = 150 + ( [_facebookPages count] * 50 ) ; //Increase or Decrease Size of TableView
    
    if (height > 396) {
        tableView.frame = CGRectMake(10, 10, 300, 396);
    }else {
        tableView.frame = CGRectMake(10, 10, 300, height); 
    }
    [tableView reloadData];
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark -
#pragma mark Memory management
- (void)viewDidUnload
{
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
    self.tableView = nil;
}

- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
        // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}

#pragma mark Facebook Delegate

- (void)fbDidLogin {
    NSString *token = [[FacebookSingleton sharedFacebook] accessToken];
    NSDate *expirationDate = [[FacebookSingleton sharedFacebook] expirationDate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"FBAccessTokenKey"];
    [defaults setObject:expirationDate forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self loadPagesFromFacebook];
}


- (void)fbDidNotLogin:(BOOL)cancelled {
    
}


- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        
            // Nil out the session variables to prevent
            // the app from thinking there is a valid session
        if (nil != [facebook accessToken]) {
            facebook.accessToken = nil;
        }
        if (nil != [facebook expirationDate]) {
            facebook.expirationDate = nil;
        }
    }
}

- (void)requestLoading:(FBRequest *)request {
    [self.progressHUD showUsingAnimation:YES];
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    if ([response statusCode] == 200) {
        
    }
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    
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
    
    id x  = [result objectForKey:@"data"];
    self.facebookPages = x;
    [self makeSizeOfTable];
    
        //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Avnish Here is facebook data" message:[x description] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //  [alert show];
        //  [alert release];
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data {
    
}

@end
