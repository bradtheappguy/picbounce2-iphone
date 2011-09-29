//
//  ExpandingPhotoView.m
//  PicBounce2
//
//  Created by Brad Smith on 11/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "PBExpandingPhotoView.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"

#import <QuartzCore/QuartzCore.h>

#define BG_COLOR [UIColor colorWithRed:0.945 green:0.933 blue:0.941 alpha:1.0]
#define ACTION_BOX_BG_COLOR [UIColor colorWithRed:0.92 green:0.90 blue:0.88 alpha:1]
#define ACTION_BOX_CORNER_RADIUS 5
#define AVATAR_FRAME CGRectMake(9, 0, 43, 44)
#define ACTION_BOX_FRAME CGRectMake(9, 48, 43, 130)
#define AVATAR_IMAGE @"avatar.png"


@implementation PBExpandingPhotoView

@synthesize datum, tableView;

-(id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])  {
      self.backgroundColor = BG_COLOR;
      self.contentStretch = CGRectMake(0.5, 0.5, 0, 0); //When resizing only strech the middle pixel

           
      
      //configure the action box
      actionBox = [[UIView alloc] initWithFrame:ACTION_BOX_FRAME];
      actionBox.backgroundColor = ACTION_BOX_BG_COLOR;
      actionBox.alpha = 0;
      actionBox.layer.cornerRadius = ACTION_BOX_CORNER_RADIUS;
      UIButton *smileyButton = [UIButton buttonWithType:UIButtonTypeCustom];
      smileyButton.showsTouchWhenHighlighted = YES;
      [smileyButton setImage:[UIImage imageNamed:@"btn_smiley.png"] forState:UIControlStateNormal];
      [smileyButton setFrame:CGRectMake(0, 0 * 43, 43, 43)];
      [actionBox addSubview:smileyButton];
      
      UIButton *chatBubbleButton = [UIButton buttonWithType:UIButtonTypeCustom];
      chatBubbleButton.showsTouchWhenHighlighted = YES;
      [chatBubbleButton setImage:[UIImage imageNamed:@"btn_comment_bubble.png"] forState:UIControlStateNormal];
      [chatBubbleButton setFrame:CGRectMake(0, 1 * 43, 43, 43)];
      [actionBox addSubview:chatBubbleButton];
      
      UIButton *mapMarkerButton = [UIButton buttonWithType:UIButtonTypeCustom];
      mapMarkerButton.showsTouchWhenHighlighted = YES;
      [mapMarkerButton setImage:[UIImage imageNamed:@"btn_map_marker2.png"] forState:UIControlStateNormal];
      [mapMarkerButton setFrame:CGRectMake(0, 2 * 43, 43, 43)];
      [actionBox addSubview:mapMarkerButton];
      
      [self addSubview:actionBox];
      [actionBox release];
      
      
    //  avatarView = [[UIImageView alloc] initWithFrame:AVATAR_FRAME];
     // avatarView.image = [UIImage imageNamed:AVATAR_IMAGE];
     
      avatarView = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:AVATAR_IMAGE]];
      avatarView.layer.cornerRadius = 5;
      avatarView.frame = AVATAR_FRAME;
      avatarView.backgroundColor = [UIColor blueColor];
      [avatarView addTarget:self action:@selector(avatarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
      
      [self addSubview:avatarView];
      [avatarView release];
      
      pictureView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
      pictureView.backgroundColor = [UIColor clearColor];
      pictureView.contentMode = UIViewContentModeCenter;
      pictureView.clipsToBounds = YES;
      [self addSubview:pictureView];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)]; 
      tap.numberOfTapsRequired = 1;
      [pictureView addGestureRecognizer:tap];
      [pictureView setUserInteractionEnabled:YES];
      [tap release];

      
    }
  return self;
}




- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[pictureView cancelImageLoad];
	}
}

-(void) layoutSubviews {
  CGRect rrect = CGRectMake(60, 0.0, self.bounds.size.width-60-10, self.bounds.size.height-10);
	CGFloat radius = 5.0;
	CGFloat minx = CGRectGetMinX(rrect),  maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),  maxy = CGRectGetMaxY(rrect);
  CGRect rectangle = CGRectMake(minx+radius,miny+radius,(maxx-minx)-(2*radius),(maxy-miny)-(2*radius));
  pictureView.frame = rectangle;
  NSLog(@"%f",rectangle.size.height);
}


-(void) viewWasTapped:(id)sender {

  BOOL expanded = [[datum objectForKey:@"expanded"] boolValue];

 
  NSUInteger height;
	if (expanded)
    height = 100;
      else {
    height = 200;
  }
  [datum setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
  
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.3f];
  
  [tableView beginUpdates];
  pictureView.alpha = expanded?1:0.8;
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
  [self layoutSubviews];
  actionBox.alpha = expanded?0:1;
  [tableView endUpdates];
  
  [UIView commitAnimations];
    
}

-(void) drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();

  // As a bonus, we'll combine arcs to create a round rectangle!
	
	// Drawing with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
  CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
  
	// If you were making this as a routine, you would probably accept a rectangle
	// that defines its bounds, and a radius reflecting the "rounded-ness" of the rectangle.
	CGRect rrect = CGRectMake(60, 0.0, self.bounds.size.width-60-10, self.bounds.size.height-10);
	CGFloat radius = 5.0;
	// NOTE: At this point you may want to verify that your radius is no more than half
	// the width and height of your rectangle, as this technique degenerates for those cases.
	
	// In order to draw a rounded rectangle, we will take advantage of the fact that
	// CGContextAddArcToPoint will draw straight lines past the start and end of the arc
	// in order to create the path from the current position and the destination position.
	
	// In order to create the 4 arcs correctly, we need to know the min, mid and max positions
	// on the x and y lengths of the given rectangle.
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Next, we will go around the rectangle in the order given by the figure below.
	//       minx    midx    maxx
	// miny    2       3       4
	// midy    1       9       5
	// maxy    8       7       6
  
  
	// Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
	// form a closed path, so we still need to close the path to connect the ends correctly.
	// Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
	// You could use a similar tecgnique to create any shape with rounded corners.
	
	// Start at 1
  
	CGContextMoveToPoint(context, minx, miny+10);
	
  // Add an arc through 2 to 3
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
  
  // Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
  
	// Add an arc through 6 to 7
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
  
	// Add an arc through 8 to 9
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
  
	// Close the path
  CGContextAddLineToPoint(context, minx, miny+20);
  
  CGContextAddLineToPoint(context, minx-5, miny+15);
 
  
	CGContextClosePath(context);
  //Draw Down 10 pixels
	// Fill & stroke the path
  
  CGContextSetShadow(context, CGSizeMake(1,1.5), 1);
  CGContextBeginTransparencyLayer(context, NULL);
  CGContextDrawPath(context, kCGPathFillStroke);
  
  
  
	
  
  //CGRect rectangle = CGRectMake(minx+radius,miny+radius,(maxx-minx)-(2*radius),(maxy-miny)-(2*radius));
  //CGContextAddRect(context, rectangle);
  //CGContextStrokePath(context);
 // CGContextSetRGBFillColor(context, 0.6,0.6,0.6,1);
 //CGContextSetRGBFillColor(context, 1,1,0,1);
  
  //CGContextFillRect(context, rectangle);

  CGContextEndTransparencyLayer(context);
  
  
}

-(void) setDatum:(NSMutableDictionary *)dictionary {
  [datum release];
  datum = [dictionary retain];
  NSDictionary *photo = [dictionary objectForKey:@"photo"];
  NSString *uuid = [photo objectForKey:@"uuid"];
  if (!pictureView.imageURL)
      
    
    pictureView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://s3.amazonaws.com/com.clixtr.picbounce/photos/%@/big.jpg",uuid]];
  BOOL expanded = [[datum objectForKey:@"expanded"] boolValue];
  actionBox.alpha = expanded?1:0;

   NSString *avatar_url = [photo objectForKey:@"twitter_avatar_url"];
  avatarView.imageURL = [NSURL URLWithString:avatar_url];
  avatarView.layer.cornerRadius = 5;
  [avatarView.layer setMasksToBounds:YES];

}

-(void) avatarButtonPressed:(id) sender {
  [tableView.delegate performSelector:@selector(avatarButtonPressed:) withObject:self];
}

@end
