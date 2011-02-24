//
//  ContainerView.m
//  PathBoxes
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "ContainerView.h"
#import "ExpandingPhotoView.h"

@implementation ContainerView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) layoutSubviews {
  [super layoutSubviews];
  self.contentSize = CGSizeMake(320, 1000);
}


-(void)expandCell:(ExpandingPhotoView *)cellToExpand {
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  for (ExpandingPhotoView *cell in self.subviews) {
    if (cell.frame.origin.y < cellToExpand.frame.origin.y) {
      cell.center = cell.center;
    }
    else if (cell.frame.origin.y == cellToExpand.frame.origin.y) {
      cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height+100);
    }
    else if (cell.frame.origin.y > cellToExpand.frame.origin.y) {
      cell.center = CGPointMake(cell.center.x, cell.center.y+100);
    }
  }
  [UIView commitAnimations];
}

-(void)contractCell:(ExpandingPhotoView *)cellToExpand {
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  for (ExpandingPhotoView *cell in self.subviews) {
    if (cell.frame.origin.y < cellToExpand.frame.origin.y) {
      cell.center = cell.center;
    }
    else if (cell.frame.origin.y == cellToExpand.frame.origin.y) {
      cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height-100);
    }
    else if (cell.frame.origin.y > cellToExpand.frame.origin.y) {
      cell.center = CGPointMake(cell.center.x, cell.center.y-100);
    }
  }
  [UIView commitAnimations];
}


- (void)dealloc {
    [super dealloc];
}

-(void) drawRect:(CGRect)rect {
  NSLog(@"x");
}

@end
