//
//  TableTitleTableViewCell.h
//
//  Created by BradSmith on 2/23/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PBTableTitleTableViewCell : UITableViewCell {
  IBOutlet UILabel *textLabel;
}
@property(nonatomic, retain) IBOutlet UILabel *textLabel;
@end
