//
//  PBCommentListViewController.m
//  PicBounce2
//
//  Created by BradSmith on 2/24/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import "PBCommentListViewController.h"
#import "PBCommentCell.h"

@implementation PBCommentListViewController


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

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 70;
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
    if (indexPath.row %2 == 0) {
   
    [customCell.a_FollowButton setBackgroundImage:[UIImage imageNamed:@"btn_following_s@2x.png"] forState:UIControlStateNormal];
        [customCell.a_FollowButton setTitle:@"Following" forState:UIControlStateNormal];
        [customCell.a_FollowButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
//    CGSize size = [[chatMessageDictionary objectForKey:@"Message"] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(246, 9999) lineBreakMode:0];
//    NSLog(@"%f   %f",size.width, size.height);
//    
//    NSInteger numOfLines = size.height / 12;
//    if (numOfLines == 1) {
//        customCell.middleImageView.frame = CGRectMake(customCell.middleImageView.frame.origin.x, customCell.middleImageView.frame.origin.y, customCell.middleImageView.frame.size.width, 15);
//    }
//    else {
//        customCell.middleImageView.frame = CGRectMake(customCell.middleImageView.frame.origin.x, customCell.middleImageView.frame.origin.y, customCell.middleImageView.frame.size.width, 12*(numOfLines));
//    }

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
   
   
@end

