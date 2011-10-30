//
//  PhotoCell.h
//
//  Created by BradSmith on 2/22/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EGOImageView.h"
#import "ASIHTTPRequest.h"
#import "OHAttributedLabel.h"


@interface PBPhotoCell : UITableViewCell <UIActionSheetDelegate, OHAttributedLabelDelegate> {
  UITableViewController *tableViewController;

    ASIHTTPRequest *_followingRequest;
}

+ (CGFloat) heightWithPhoto:(NSDictionary *)photo;
- (void) addPhotoView:(UIView *)view ToFollowerScrollViewAtIndex:(NSUInteger) index;

- (IBAction)commentButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;

@property (nonatomic, assign) UITableViewController *tableViewController;
@property (retain, nonatomic) IBOutlet UIView *actionBar;

@property (nonatomic, retain) NSDictionary *photo; 


@property (nonatomic, retain)IBOutlet  EGOImageView  *photoImageView;

@property (nonatomic, retain) IBOutlet UILabel *captionLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentCountLabel;

@property (retain, nonatomic) IBOutlet UIImageView *commentCountIcon;


@property (nonatomic, retain) IBOutlet UIButton *leaveCommentButton;
@property (retain, nonatomic) IBOutlet id commentPreview;


@end
