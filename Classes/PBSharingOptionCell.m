//
//  PBSharingOptionCell.m
//  PicBounce2
//
//  Created by Avnish Chuchra on 26/10/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBSharingOptionCell.h"

@implementation PBSharingOptionCell
@synthesize a_TitleLabel;
@synthesize a_StatusButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
        
    
    return  self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
        // Configure the view for the selected state
}


- (void)dealloc {
    [a_TitleLabel release];
    [a_StatusButton release];
    
    [super dealloc];
}


@end
