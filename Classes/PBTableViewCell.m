//
//  MyTableViewCell.m
//  PathBoxes
//
//  Created by Brad Smith on 11/24/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "PBTableViewCell.h"

#define kExpandingPhotoViewTopPadding 10
#define kExpandingPhotoViewCollapsedHeight 100
#define kExpandingPhotoViewExpandedHeight 200



@implementation PBTableViewCell

@synthesize datum, tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		content = [[PBExpandingPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, kExpandingPhotoViewCollapsedHeight)];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
		content.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
		[self.contentView addSubview: content];
    self.frame = CGRectMake(0, 0, 320, kExpandingPhotoViewCollapsedHeight);
    label = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 240, 80)];
    label.numberOfLines = 7;
    label.font = [UIFont boldSystemFontOfSize:17];
    label.contentMode = UIViewContentModeTop;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    //label.shadowColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    
	}
	return self;
}


-(void) setDatum:(NSMutableDictionary *)d {
 NSDictionary *photo = [d objectForKey:@"photo"];
  NSString *caption = [d objectForKey:@"name"];
  if (caption) {
    if (![caption isEqual:[NSNull null]]) {
      CGSize size = [caption sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
      label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,size.width, size.height);
      label.text = caption;
      label.textColor = [UIColor blackColor];
    }
    
  }
  
  [datum release];
  datum = nil;
  datum = [d retain];
  content.datum = d;
  
  
  NSUInteger height = [[datum objectForKey:@"expanded"] boolValue]?kExpandingPhotoViewExpandedHeight:100;
  content.frame = CGRectMake(0, kExpandingPhotoViewTopPadding, 320, height);
}

-(void) setTableView:(UITableView *)tv {
  [tableView release];
  tableView = nil;
  tableView = [tv retain];
  content.tableView = tv;
}



@end
