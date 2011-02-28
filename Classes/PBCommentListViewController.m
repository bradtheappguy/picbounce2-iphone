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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  self.tableView.superview;
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:99 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
//  [super viewWillDisappear:animated];
  [textField resignFirstResponder];
  
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 100;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
 
  
    if (indexPath.row == 99) {
      cell.contentView.backgroundColor = [UIColor redColor];
      textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 4, 320-60, 35)];
      textField.delegate = self;
      textField.returnKeyType = UIReturnKeySend;
      [textField setBackgroundColor:[UIColor whiteColor]];
      [cell.contentView addSubview:textField];
    }
  else {
    cell.textLabel.text = @"Dr Dre.";
    
    cell.detailTextLabel.text = @"I am a comment";
    cell.imageView.image = [UIImage imageNamed:@"btn_smiley.png"]; 
  }

  
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void)keyboardWillShow:(NSNotification *)notification {
  
  /*
   Reduce the size of the text view so that it's not obscured by the keyboard.
   Animate the resize so that it's in sync with the appearance of the keyboard.
   */
  
  NSDictionary *userInfo = [notification userInfo];
  
  // Get the origin of the keyboard when it's displayed.
  NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  
  // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
  CGRect keyboardRect = [aValue CGRectValue];
  keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
  
  CGFloat keyboardTop = keyboardRect.origin.y;
  
  
  CGRect newTextViewFrame = textEntryView.bounds;
  newTextViewFrame.origin.y =  textEntryView.frame.origin.y - 167;
  
  // Get the duration of the animation.
  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];
  
  // Animate the resize of the text view's frame in sync with the keyboard's appearance.
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  
  textEntryView.frame = newTextViewFrame;
  
  [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
  
  /*
   Reduce the size of the text view so that it's not obscured by the keyboard.
   Animate the resize so that it's in sync with the appearance of the keyboard.
   */
  
  NSDictionary *userInfo = [notification userInfo];
  
  // Get the origin of the keyboard when it's displayed.
  NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  
  // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
  CGRect keyboardRect = [aValue CGRectValue];
  keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
  
  CGFloat keyboardTop = keyboardRect.origin.y;
  
  
  CGRect newTextViewFrame = textEntryView.bounds;
  newTextViewFrame.origin.y =  textEntryView.frame.origin.y + 167;
  
  // Get the duration of the animation.
  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];
  
  // Animate the resize of the text view's frame in sync with the keyboard's appearance.
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  
 // textEntryView.frame = newTextViewFrame;
  
  [UIView commitAnimations];
}

@end

