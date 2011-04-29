//
//  AccountSettingView.m
//  PicBounce2
//
//  Created by Nitin on 4/20/11.
//  Copyright 2011 Ampere Software Private Limited. All rights reserved.
//

#import "AccountSettingView.h"
#import "FBConnect.h"
#import "FacebookSingleton.h"
@implementation AccountSettingView

@synthesize fbbutton;
@synthesize facebook = _facebook;
@synthesize label = label;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    _permissions =  [[NSArray arrayWithObject: @"publish_stream"] retain];
  }
  return self;
}


- (void)dealloc {
  [_permissions release];
  [_facebook release];
  _facebook = nil;
  [serviceNames release];
  [super dealloc];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];  
  self.title = NSLocalizedString(@"Account Settings",nil);
  serviceNames	= [[NSArray arrayWithObjects:
                    NSLocalizedString(@"Facebook",nil), 
                    NSLocalizedString(@"Twitter",nil),
                    NSLocalizedString( @"Flicker",nil ),
                    NSLocalizedString(@"Tumbler",nil),
                    NSLocalizedString(@"Posterous",nil),
                    NSLocalizedString(@"MySpace",nil), nil] retain];    
  
  accountTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 415) style:UITableViewStyleGrouped] autorelease];
  accountTable.dataSource = self;
  accountTable.delegate = self;
  accountTable.userInteractionEnabled = YES;
  [self.view addSubview:accountTable];
}


- (void)viewDidUnload {
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
    [self logout];
  }
  else {
    [sender setImage:selected forState:UIControlStateSelected];
    [sender setSelected:YES];
    [self login];
  }
}


#pragma mark Facebook Logout

- (void)login {
  
  BOOL isLoggedIn;
  
	if (_facebook == nil) {
		_facebook = [FacebookSingleton sharedFacebook];
		_facebook.sessionDelegate = self;
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
		NSDate *exp = [[NSUserDefaults standardUserDefaults] objectForKey:@"exp_date"];
		
		if (token != nil && exp != nil && [token length] > 2) {
			isLoggedIn = YES;
			_facebook.accessToken = token;
      _facebook.expirationDate = [NSDate distantFuture];
		} 
		
		
		[_facebook retain];
	}
	
  //if no session is available login
	[_facebook authorize:_permissions   delegate:self];
}


- (void)logout {  
  [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"exp_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
  [_facebook logout:self];
}


- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate{
  
  if (_path != nil) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		
		if (_delegate == nil)
			_delegate = self;
		
		[_facebook requestWithGraphPath:@"me" andDelegate:self];
	}
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  //#warning Potentially incomplete method implementation.
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //#warning Incomplete method implementation.
  // Return the number of rows in the section.
  return [serviceNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  if (indexPath.section == 0 ) {
    
    cell.textLabel.text = [serviceNames objectAtIndex:indexPath.row];
    
    
    if (indexPath.row == 0) {  ////set the button for facebook
      
      
      fbview = [[[UIView alloc]initWithFrame:CGRectMake(200, 7, 80,30)]autorelease];
      //fbview.backgroundColor = [UIColor redColor];
      
      fbbutton = [UIButton buttonWithType:UIButtonTypeCustom];
      fbbutton.frame = CGRectMake(0, 0, 80,30);
      [fbbutton addTarget:self action:@selector(facebooklogin:) forControlEvents:UIControlEventTouchUpInside];
      
      [fbbutton setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
      [fbview addSubview:fbbutton];
      
      
      
      [cell.contentView addSubview:fbview]; 
      
      
      
    }
  }
  
  // Configure the cell...
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancel otherButtonTitles:(NSString *)otherButonTitles, ... {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:otherButonTitles,nil];
  [alert show];
  [alert release];
}

-(void) fbDidLogin {
  NSLog(@"I DID LOGZ INTQQQQQ");
}

- (void)fbDidNotLogin:(BOOL)cancelled {
  NSLog(@"FFFF");
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
  NSLog(@"ssss");
}
@end
