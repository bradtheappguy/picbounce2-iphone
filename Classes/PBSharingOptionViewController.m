    //
    //  PBSharingOptionViewController.m
    //  PicBounce2
    //
    //  Created by Avnish Chuchra on 26/10/11.
    //  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
    //

#import "PBSharingOptionViewController.h"
#import "PBSharingOptionCell.h"
#import "Checkbox.h"
#import "FacebookSingleton.h"

#define kIndent 50
#define kOffset(val) 5

@implementation PBSharingOptionViewController
@synthesize a_OptionsTableView;
@synthesize a_OptionArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        // Return the number of rows in the section.
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
    
    
    if (indexPath.row == 0) {
        [customCell.a_StatusButton setTitle:@"Login" forState:UIControlStateNormal];
        [customCell.a_TitleLabel setText:@"Facebook"];
        [customCell.a_StatusButton setTag:indexPath.row];
        [customCell.a_StatusButton addTarget:self action:@selector(loginlogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 1) {
        [customCell.a_StatusButton setTitle:@"Logout" forState:UIControlStateNormal];
        [customCell.a_TitleLabel setText:@"Twitter"];
        [customCell.a_StatusButton setTag:indexPath.row];
        [customCell.a_StatusButton addTarget:self action:@selector(loginlogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [customCell.a_StatusButton setHidden:YES];
        [customCell.a_TitleLabel setText:@""];
        
        Checkbox *EWCheckbox = [[Checkbox alloc] initWithPosition:CGPointMake(kIndent, kOffset(5))];
        [EWCheckbox setText:@"Market Edition"];
        [EWCheckbox setTag:indexPath.row];
        EWCheckbox.selected = YES;//[getValDef(@"ewEdition",[NSNumber numberWithInt:1]) boolValue];
        [EWCheckbox addTarget:self action:@selector(ewTouched:) forControlEvents:UIControlEventTouchUpInside];
        [customCell.contentView addSubview:EWCheckbox];
        [EWCheckbox release];
    }
    return customCell;
}
- (void)ewTouched:(UIButton *)sender {
    
}
- (void)loginlogoutButton:(UIButton *)sender {
    if (sender.tag == 0) {
        facebook = [FacebookSingleton sharedFacebook];
        [facebook logout:self];
    }
  
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
    self.a_OptionsTableView = nil;
}

- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
        // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [a_OptionsTableView release];
    [super dealloc];
}
@end
