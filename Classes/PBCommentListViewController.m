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
@implementation PBCommentListViewController
@synthesize a_CommentsArray;
@synthesize a_IDString;
#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor lightGrayColor];
  //  tableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
  //    tableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLineEtched;
    tableView.separatorStyle    = UITableViewCellSeparatorStyleNone;
}



- (void)viewDidAppear:(BOOL)animated {
 // [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] atScrollPosition://UITableViewScrollPositionTop animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:nil];
    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [a_CommentsArray count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[a_CommentsArray objectAtIndex:indexPath.row] valueForKey:@"item"]];
    CGSize size = [[dict valueForKey:@"caption"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] constrainedToSize:CGSizeMake(166, 9999) lineBreakMode:UILineBreakModeWordWrap];
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
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[a_CommentsArray objectAtIndex:indexPath.row] valueForKey:@"item"]];
    NSLog(@"%@",dict);
    if (indexPath.row %2 == 0) {
   
    [customCell.a_FollowButton setBackgroundImage:[UIImage imageNamed:@"btn_following_s@2x.png"] forState:UIControlStateNormal];
        [customCell.a_FollowButton setTitle:@"Following" forState:UIControlStateNormal];
        [customCell.a_FollowButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
   customCell.a_CommentUserNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
   customCell.a_CommentUserNameLabel.textColor = [UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:56.0f/255.0f alpha:1.0];
        //color:  77/255.0  65/255.0 56/255.0
    customCell.a_CommentUserNameLabel.text =  [[dict valueForKey:@"user"] valueForKey:@"screen_name"];
    
    
    
    CGSize size = [[dict valueForKey:@"caption"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] constrainedToSize:CGSizeMake(166, 9999) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"%f   %f",size.width, size.height);
    
    NSInteger numOfLines = size.height / 12;
    if (numOfLines == 1) {
        customCell.a_CommentLabel.frame = CGRectMake(customCell.a_CommentLabel.frame.origin.x, customCell.a_CommentLabel.frame.origin.y, customCell.a_CommentLabel.frame.size.width, 15);
    }
    else {
        customCell.a_CommentLabel.frame = CGRectMake(customCell.a_CommentLabel.frame.origin.x, customCell.a_CommentLabel.frame.origin.y, customCell.a_CommentLabel.frame.size.width, 12*(numOfLines));
    }
    if (size.height > 30) {
        customCell.a_CommentCellBackGroundImageView.frame = CGRectMake(customCell.a_CommentCellBackGroundImageView.frame.origin.x, customCell.a_CommentCellBackGroundImageView.frame.origin.y, customCell.a_CommentCellBackGroundImageView.frame.size.width, customCell.a_CommentCellBackGroundImageView.frame.size.height + (12*(numOfLines) - 30));
    }
    customCell.a_CommentLabel.numberOfLines = numOfLines;
   customCell.a_CommentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
   customCell.a_CommentLabel.textColor = [UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:56.0f/255.0f alpha:1.0];
    
    customCell.a_CommentPersonImageView.imageURL = [NSURL URLWithString:[[dict valueForKey:@"user"] valueForKey:@"avatar"]];
    customCell.a_CommentLabel.text = [dict valueForKey:@"caption"];
    dict = nil;
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
    [a_CommentsArray release];
    [a_IDString release];
    [super dealloc];
}




- (void)keyboardWillShow:(NSNotification *)notification {
 [self moveViewsForKeyboard:notification up:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
}


- (void) textFieldDidBeginEditing:(UITextField *)f {
  
}

- (void) textFieldDidEndEditing:(UITextField *)f {
  
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self downViewsForKeyboard:notification down:YES];
}
- (void) downViewsForKeyboard:(NSNotification*)aNotification down: (BOOL) up {
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
    
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    myView.center = CGPointMake(myView.center.x, myView.center.y + 216);   
    tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
    /*  CGPoint newOffset = tableView.contentOffset;
     newOffset.y += 216-50 * (up? 1 : -1);
     [tableView setContentOffset:newOffset animated:YES];
     
     tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 216-50, 0);
     tableView.contentInset = UIEdgeInsetsMake(0, 0, 216-50, 0);
     */
    [UIView commitAnimations];
    [self performSelector:@selector(postComment) withObject:nil afterDelay:0.01];
}

- (void) moveViewsForKeyboard:(NSNotification*)aNotification up: (BOOL) up{
  
  
  //CGPoint co = tableView.contentOffset;  //4078
  
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
  
  
  CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
  
  myView.center = CGPointMake(myView.center.x, myView.center.y - 216);   
  tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
  tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
  /*  CGPoint newOffset = tableView.contentOffset;
   newOffset.y += 216-50 * (up? 1 : -1);
   [tableView setContentOffset:newOffset animated:YES];
   
   tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 216-50, 0);
   tableView.contentInset = UIEdgeInsetsMake(0, 0, 216-50, 0);
   */
  [UIView commitAnimations];
  
}
- (void)postComment {
        //posts/[id]/comments?caption=I%20AM%A%20Test%20Comment
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/posts/%@/comments?caption=%@",API_BASE,a_IDString,[myView.a_CommentTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if (_followingRequest) {
        [_followingRequest cancel];
        [_followingRequest release];
        _followingRequest = nil;
    }
    _followingRequest = [[PBHTTPRequest requestWithURL:url] retain];
    _followingRequest.requestMethod = @"POST";
    _followingRequest.delegate = self;
    [_followingRequest setDidFailSelector:@selector(followingRequestDidFail:)];
    [_followingRequest setDidFinishSelector:@selector(followingRequestDidFinish:)];
    [_followingRequest startAsynchronous];
    
    
}
-(void) followingRequestDidFail:(ASIHTTPRequest *)followingRequest {
    
}

-(void) followingRequestDidFinish:(ASIHTTPRequest *)followingRequest {
    if (followingRequest.responseStatusCode == 200) {
            // NSLog(@"%@",followingRequest.responseString);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[followingRequest.responseString JSONValue]];
            NSLog(@"%@",[[[dict valueForKey:@"response"] valueForKey:@"comments"] valueForKey:@"items"] );
       
        
    }
    myView.a_CommentTextView.text = @"";
}



   
@end

