//
//  PBCommentListViewController.m
//  PicBounce2
//
//  Created by BradSmith on 2/24/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBCommentListViewController.h"


@implementation PBCommentListViewController


#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *x = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
  self.view.backgroundColor = [UIColor lightGrayColor];

  myView.scrollView = scrollView;
  UIImage *image = [UIImage imageNamed:@"btn_StrechableBlueBubble.png"];
  
  

  
  
  UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
  postButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  [postButton setBackgroundImage:image forState:UIControlStateNormal];
  [postButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.25] forState:UIControlStateNormal];
  [postButton setFont:[UIFont boldSystemFontOfSize:16]];
  [postButton setTitle:NSLocalizedString(@"Post", nil) forState:UIControlStateNormal];
  postButton.backgroundColor  = [UIColor clearColor];
  CGSize myOffset;
  myOffset.width = 0.0f;
  myOffset.height = -1.0f;
  postButton.titleShadowOffset = myOffset;
  postButton.center = CGPointMake(myView.frame.size.width - (postButton.frame.size.width / 2) - 6, 1 + (myView.frame.size.height/2));
  [myView addSubview:postButton];
  
}



- (void)viewDidAppear:(BOOL)animated {
 // [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0] atScrollPosition://UITableViewScrollPositionTop animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 25;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    

  else {
    cell.textLabel.text = @"Dr Dre.";
    
    cell.detailTextLabel.text = @"I am a comment";
    cell.imageView.image = [UIImage imageNamed:@"btn_smiley.png"]; 
  }

  
    return cell;
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

}


- (void) moveViewsForKeyboard:(NSNotification*)aNotification up: (BOOL) up{
  
  
  //CGPoint co = tableView.contentOffset;  //4078
  
  NSDictionary* userInfo = [aNotification userInfo];
  
  // Get animation info from userInfo
  NSTimeInterval animationDuration;
  UIViewAnimationCurve animationCurve;
  
  CGRect keyboardEndFrame;
  
  keyboardHeight = keyboardEndFrame.size.height;
  
  [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
  [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
  
  
  [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
  
  
  // Animate up or down
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationCurve:animationCurve];
  
  
  CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
  
  myView.center = CGPointMake(myView.center.x, myView.center.y - 216);   
  scrollView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
  scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 216, 0);
  /*  CGPoint newOffset = tableView.contentOffset;
   newOffset.y += 216-50 * (up? 1 : -1);
   [tableView setContentOffset:newOffset animated:YES];
   
   tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 216-50, 0);
   tableView.contentInset = UIEdgeInsetsMake(0, 0, 216-50, 0);
   */
  [UIView commitAnimations];
  
}
   
   
@end

