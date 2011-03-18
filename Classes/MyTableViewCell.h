//
//  MyTableViewCell.h
//  PathBoxes
//
//  Created by Brad Smith on 11/24/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandingPhotoView.h"

@interface MyTableViewCell : UITableViewCell {
  NSMutableDictionary *datum;
  ExpandingPhotoView *content; 
  
  UILabel *label;
  UITableView *tableView;
}

@property (nonatomic, retain)   NSMutableDictionary *datum;
@property (nonatomic, assign)   UITableView *tableView;

@end