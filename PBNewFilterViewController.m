//
//  PBFilterViewController.m
//  PicBounce2
//
//  Created by Brad Smith on 11/12/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

//#define USE_TOMDIZ_FILTERS
#define USE_TV_FILTERS

#import "PBNewFilterViewController.h"
#import "PBNewPostViewController.h"
//#import "PBFilterManager.h"
#import "TVImageFilterController.h"
#import "UIImage+Resize.m"

@implementation PBNewFilterViewController

@synthesize imageView;
@synthesize filterScrollView;

#pragma mark - View lifecycle

-(void) configureFilterScrollView {
  #ifdef USE_TOMDIZ_FILTERS 
    filterManager = [[PBFilterManager alloc] init:self];
    [filterManager loadFilterPList];
    [PBFilterManager createFilterButtonImages:NO];
    CGFloat width = [filterManager layoutFilterView:filterScrollView];
    [filterManager setDelegate:self];
    CGSize newSize = filterScrollView.bounds.size;
    newSize.width = width;
    filterScrollView.contentSize = newSize;
  #endif
  
  #ifdef USE_TV_FILTERS
    filterScrollView.alwaysBounceHorizontal = YES;
    NSUInteger numberOfFilters = 13;
    NSUInteger margin = 11; 
    
  
    UIImage *thumb = [self.imageView.image thumbnailImage:45 transparentBorder:0 cornerRadius:5 interpolationQuality:kCGInterpolationMedium];
  
    for (int c=0; c<(numberOfFilters + 1); c++) {
      UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      button.tag = c;
      button.frame = CGRectMake(60*c + margin, 10, 45, 45);
      [button addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
      [filterScrollView addSubview:button];
      
      if (c == 0) {
        [button setImage:thumb forState:UIControlStateNormal];
      }
      else {
        [button setImage:[TVImageFilterController filteredImageWithImage:thumb filter:c-1] forState:UIControlStateNormal];
      }
      
      UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(60*c + margin, 13+45, 45, 15)];
      l.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
      l.textColor = [UIColor whiteColor];
      l.textColor = [UIColor colorWithRedInt:177 greenInt:173 blueInt:176 alphaInt:255];
      l.shadowColor = [UIColor colorWithRedInt:0 greenInt:0 blueInt:0 alphaInt:255];
      l.shadowOffset = CGSizeMake(0, -1);
      l.backgroundColor = [UIColor clearColor];
      l.text = @"Original";
      l.textAlignment = UITextAlignmentCenter;
      [filterScrollView addSubview:l];
    }
    filterScrollView.contentSize = CGSizeMake((60*numberOfFilters) + 45 + (margin*2), filterScrollView.bounds.size.height);
    filterScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 64, 0);

  #endif
}

-(void)dealloc {
  [imageView release];
  [originalImage release];
  [super dealloc];
}


- (void)viewDidUnload {
    [self setImageView:nil];
  [originalImage release];
  originalImage = nil;
    [super viewDidUnload];
}


-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}


-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [(UIImagePickerController *)self.navigationController setShowsCameraControls: YES];
}


-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.imageView.image == nil) {
    NSLog(@"ERROR: ==========================");
    NSLog(@"Camera did not send data to filter view controller!!!=");
  }
  [self configureFilterScrollView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark button handeling
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

- (void) filterButtonPressed:(UIButton *)sender {
  if (!originalImage) {
    originalImage = [self.imageView.image copy];
  }
  if (sender.tag == 0) {
    self.imageView.image = originalImage;
  }
  else {
    self.imageView.image = [TVImageFilterController filteredImageWithImage:originalImage filter:sender.tag - 1];
  }
}


#pragma filter notifier delegate
- (void)filterProcessingCompleteRefreshView:(UIImage *)image {
  self.imageView.image = image;
  [self.imageView setNeedsDisplay];
  NSLog(@"filterProcessingCompleteRefreshView");
}

@end
