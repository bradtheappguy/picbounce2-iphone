//
//  PBCommentListViewController.m
//  PicBounce2
//
//  Created by BradSmith on 2/24/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBCommentListViewController.h"
#import "PBCommentCell.h"
#import "PBHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "NSDictionary+NotNull.h"
#import "PBAPI.h"

@implementation PBCommentListViewController
@synthesize url = _url;
@synthesize uploadedComments;
@synthesize comments;

@synthesize postID;
@synthesize progressHUD = _progressHUD;
@synthesize postCommentRequest;
@synthesize getCommentsRequest;

#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
  [super viewDidLoad];
        //self.view.backgroundColor = [UIColor redColor];

    tableView.separatorStyle    = UITableViewCellSeparatorStyleNone;
  PBProgressHUD *hud =  [[PBProgressHUD alloc] initWithView:self.view];
  hud.labelText = @"Loading...";
  self.progressHUD = hud;
  
  [hud release];
  [self.view addSubview:self.progressHUD];
	
	UINavigationItem *previousItem;
	
    previousItem = [[[UINavigationItem alloc] initWithTitle:@"Back"] autorelease];

	self.navigationController.title = @"Comments";
	//[self.navigationController.navigationBar setItems:[NSArray arrayWithObjects:previousItem, nil]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWasFollowedNotificationReceived:) name:PBAPIUserWasFollowedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWasUnfollowedNotificationReceived:) name:PBAPIUserWasUnfollowedNotification object:nil];  
}



- (void)viewDidAppear:(BOOL)animated {
 // [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] atScrollPosition://UITableViewScrollPositionTop animated:YES];
  [self.progressHUD showUsingAnimation:YES];
  self.getCommentsRequest = [PBHTTPRequest requestWithURL:self.url];
  self.getCommentsRequest.requestMethod = @"GET";
  self.getCommentsRequest.delegate = self;
  [self.getCommentsRequest setDidFailSelector:@selector(getCommentsRequestDidFail:)];
  [self.getCommentsRequest setDidFinishSelector:@selector(getCommentsRequestDidFinish:)];
  [self.getCommentsRequest startAsynchronous];

}



- (void)viewWillAppear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postComment) name:@"PostComment" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostComment" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  
  [self.getCommentsRequest setDelegate:nil];
  [self.getCommentsRequest cancel];
  self.getCommentsRequest = nil; 
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
  if (section == 0) {
    return [self.uploadedComments count];
  }  
  return [comments count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[comments objectAtIndex:indexPath.row] valueForKey:@"item"]];
    CGSize size = [[dict objectForKeyNotNull:@"text"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] constrainedToSize:CGSizeMake(166, 9999) lineBreakMode:UILineBreakModeWordWrap];
    if (size.height > 30) {
        NSInteger numOfLines = size.height / 12;
        
        return 60 + ((numOfLines*12) - 30);
    }
  return 60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    static NSString *CellIdentifier = @"MyMessageCell";
    PBCommentCell *customCell = (PBCommentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (customCell == nil) {
      
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PBCommentCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
            {
            if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                customCell = (PBCommentCell *) currentObject;
                customCell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                }
            }
    }
  NSMutableDictionary *comment;
  if (indexPath.section == 1) {
    comment  = [[comments objectAtIndex:indexPath.row] valueForKey:@"item"];
  }
  else {
    comment = [[self.uploadedComments objectAtIndex:indexPath.row] valueForKey:@"item"];
  }
  [customCell setViewController:self];
  [customCell setComment:comment];

  return customCell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)dealloc {
 
    [comments release];
    [postID release];
    [super dealloc];
}




- (void)keyboardWillShow:(NSNotification *)notification {
 [self moveViewsForKeyboard:notification up:YES];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [self downViewsForKeyboard:notification down:YES];
}

- (void) downViewsForKeyboard:(NSNotification*)aNotification down: (BOOL) up {
    NSDictionary* userInfo = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    myView.center = CGPointMake(myView.center.x, myView.center.y + 216);   
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void) moveViewsForKeyboard:(NSNotification*)aNotification up: (BOOL) up{
  NSDictionary* userInfo = [aNotification userInfo];
  
  // Get animation info from userInfo
  NSTimeInterval animationDuration;
  UIViewAnimationCurve animationCurve;
  CGRect keyboardEndFrame;
  [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
  [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
  [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
  
  
  // Animate up or down
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationCurve:animationCurve];

  
  myView.center = CGPointMake(myView.center.x, myView.center.y - 216);   
  tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardEndFrame.size.height, 0);
  tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardEndFrame.size.height, 0);

  [UIView commitAnimations];
  
}
- (void)postComment {

  NSString *textToPost = myView.a_CommentTextView.text;
  
  NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:@"http://bigfrosty.heroku.com/images/empty_avatar_large.png",@"avatar",
                        @"my name",@"screen_name",nil];
  NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:textToPost,@"text", user, @"user",nil];
  
  NSDictionary *newComment = [NSDictionary dictionaryWithObject:item
                                                         forKey:@"item"];
  self.uploadedComments = [[NSMutableArray alloc] initWithObjects:newComment, nil];
  
  
  
  
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/posts/%@/comments?text=%@",API_BASE,self.postID,[textToPost stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if (self.postCommentRequest) {
        [self.postCommentRequest cancel];
        self.postCommentRequest = nil;
    }
    self.postCommentRequest = [[PBHTTPRequest requestWithURL:url] retain];
    self.postCommentRequest.requestMethod = @"POST";
    self.postCommentRequest.delegate = nil;
    [self.postCommentRequest setDidFailSelector:@selector(postCommentRequestDidFail:)];
    [self.postCommentRequest setDidFinishSelector:@selector(postCommentRequestDidFinish:)];
    [self.postCommentRequest startAsynchronous];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Networking Callbacks
-(void) postCommentRequestDidFail:(ASIHTTPRequest *)followingRequest {
    
}

-(void) postCommentRequestDidFinish:(ASIHTTPRequest *)followingRequest {
    if (followingRequest.responseStatusCode == 200) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[followingRequest.responseString JSONValue]];
            NSLog(@"%@",[[[dict valueForKey:@"response"] valueForKey:@"comments"] valueForKey:@"items"] );
       
        
    }
    myView.a_CommentTextView.text = @"";
}

-(void) getCommentsRequestDidFail:(ASIHTTPRequest *)followingRequest {
  [self.progressHUD hide:YES];
  PBProgressHUD *errorHud = [[PBProgressHUD alloc] initWithView:self.view];
  errorHud.mode = PBProgressHUDModeError;
  [errorHud retain];
  [self.view addSubview:errorHud];
  errorHud.labelText = @"Error";
  [errorHud showUsingAnimation:YES];
  [errorHud performSelector:@selector(hideUsingAnimation:) withObject:self afterDelay:2.0];
}

-(void) getCommentsRequestDidFinish:(ASIHTTPRequest *)followingRequest {
  if (followingRequest.responseStatusCode == 200) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[followingRequest.responseString JSONValue]];
    self.postID = [[[dict valueForKey:@"response"] valueForKey:@"post"] valueForKey:@"id"];
    self.comments = [[[dict valueForKey:@"response"] valueForKey:@"comments"] valueForKey:@"items"];
    [self.progressHUD hide:YES];
    [tableView reloadData];
  }
  else {
    [self getCommentsRequestDidFail:followingRequest];
  }
  self.getCommentsRequest = nil;
}

#pragma mark -
#pragma mark

 
-(void) userWasFollowedNotificationReceived:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  //NSString *senderUserID = [[[userInfo objectForKey:@"user"] objectForKey:@"id"] stringValue];
  for (NSDictionary *comment in self.comments) {
    NSLog(@"comment %@",comment);
  }
}
 
-(void) userWasunFollowedNotificationReceived:(NSNotification *)notification {
  NSDictionary *user = [notification userInfo];
  NSLog(@" %@",user);
}




   
@end

