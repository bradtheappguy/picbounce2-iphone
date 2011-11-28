//
//  PBFilterViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 11/12/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBNewFilterViewController.h"
#import "PBNewPostViewController.h"
//#import "PBFilterManager.h"

@implementation PBNewFilterViewController
@synthesize imageView;
@synthesize filterScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) configureFilterScrollView {

//  filterManager = [[PBFilterManager alloc] init:self];
//  [filterManager loadFilterPList];
//  [PBFilterManager createFilterButtonImages:NO];
//  CGFloat width = [filterManager layoutFilterView:filterScrollView];
  [filterManager setDelegate:self];
  
//  CGSize newSize = filterScrollView.bounds.size;
//  newSize.width = width;
//  filterScrollView.contentSize = newSize;
  filterScrollView.alwaysBounceHorizontal = YES;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}
-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setShowsCameraControls: YES];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.imageView.image == nil) {
    NSLog(@"ERROR: ==========================");
    NSLog(@"Camera did not send data to filter view controller!!!=");
    
  }

  //[self configureFilterScrollView];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imageView release];
    [super dealloc];
}

#pragma mark buttons
- (IBAction)nextButtonPressed:(id)sender {
  PBNewPostViewController *newPostVC = [[PBNewPostViewController alloc] initWithNibName:@"PBNewPostViewController" bundle:nil];
  [newPostVC view];
  newPostVC.previewImageView.image = imageView.image;
  [self.navigationController pushViewController:newPostVC animated:YES];
  [newPostVC release];
}
- (IBAction)backButtonPressed:(id)sender {

  
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma filter notifier delegate
- (void)filterProcessingCompleteRefreshView:(UIImage *)image {

  self.imageView.image = image;
  [self.imageView setNeedsDisplay];
  NSLog(@"filterProcessingCompleteRefreshView");
}

@end
