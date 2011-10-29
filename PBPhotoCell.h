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
#import "TTTAttributedLabel.h"

@interface PBPhotoCell : UITableViewCell <UIActionSheetDelegate, TTTAttributedLabelDelegate> {
  UITableViewController *tableViewController;

    ASIHTTPRequest *_followingRequest;
}

+ (CGFloat) heightWithPhoto:(NSDictionary *)photo;
- (void) addPhotoView:(UIView *)view ToFollowerScrollViewAtIndex:(NSUInteger) index;

- (IBAction)commentButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;

@property (nonatomic, assign) UITableViewController *tableViewController;

@property (nonatomic, retain) NSDictionary *photo; 

@property (nonatomic, retain) IBOutlet UILabel *viewCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *bounceCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *bounceButton;
@property (nonatomic, retain)IBOutlet  EGOImageView  *photoImageView;

@property (nonatomic, retain) IBOutlet UILabel *commentLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentCountLabel;

@property (nonatomic, retain) IBOutlet UILabel *personCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *hashTagCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *likeCountLabel;

@property (nonatomic, retain) IBOutlet UIButton *leaveCommentButton;
@property (retain, nonatomic) IBOutlet id commentPreview;


@end
