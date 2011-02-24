//
//  ExpandingPhotoView.h
//  PathBoxes
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EGOImageView;
@class EGOImageButton;


@interface ExpandingPhotoView : UIView {
   
  EGOImageButton *avatarView;
  
  NSMutableDictionary *datum;
  
  UITableView *tableView;
  
  UIView *actionBox;
  
  EGOImageView* pictureView;
  
  
  
}

@property (nonatomic, assign)   UITableView *tableView;

@property (nonatomic, retain)   NSMutableDictionary *datum;

@end
