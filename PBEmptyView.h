//
//  PBEmptyView.h
//  PicBounce2
//
//  Created by Brad Smith on 11/25/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBEmptyView : UIView
@property (retain, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (retain, nonatomic) IBOutlet UILabel *urlLabel;

- (void) setUserName:(NSString *)name;
- (void) setScreenName:(NSString *)screenname;
@end
