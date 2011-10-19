//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PBRefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:103.0/255.0 green:89.0/255.0 blue:77.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor redColor]


@implementation PBRefreshTableHeaderView

@synthesize state = _state;
@synthesize circle = _circle;


- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.backgroundColor = [UIColor clearColor];
    
    CircleView *circle = [[CircleView alloc] initWithFrame:CGRectMake(8, frame.size.height - 55, 50, 50)];
    self.circle = circle;
    [circle release];
    self.circle.clipsToBounds = NO;
    self.circle.backgroundColor = [UIColor clearColor];
    [self addSubview:self.circle];

    
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, frame.size.height - 41.0f, self.frame.size.width-68, 20.0f)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
		statusLabel.textColor = TEXT_COLOR;
		statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.textAlignment = UITextAlignmentLeft;
		[self setState:PBPullRefreshNormal];
		[self addSubview:statusLabel];
		[statusLabel release];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
		
		
    activityView = nil;
		activityView.frame = CGRectMake(15+8, frame.size.height - 51 + 15, 20.0f, 20.0f);
    activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		[activityView release];
		
  }
  return self;
}



- (void)setState:(PBPullRefreshState)aState {
	
	switch (aState) {
		case PBPullRefreshPulling:
			
			statusLabel.text = @"Release to refresh";
			
			break;
		case PBPullRefreshNormal:
			
			if (_state == PBPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:.18];
				arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			statusLabel.text = @"Pull down to refresh";
			[activityView stopAnimating];
			
			break;
		case PBPullRefreshLoading:
      
			[activityView startAnimating];
      statusLabel.text = @"Loading...";
      [self performSelector:@selector(animateCircle) withObject:nil afterDelay:0.05];
			break;
		default:
			break;
	}
	
	_state = aState;
}

-(void) animateCircle {
  CGFloat progress = self.circle.progress;
  progress = progress + .020;
  if (progress > 2) {
    progress = 0;
  }  
  [self.circle setProgress:progress];
  [self.circle setNeedsDisplay];
  if (self.state == PBPullRefreshLoading) {
    [self performSelector:@selector(animateCircle) withObject:nil afterDelay:0.05];
  }
}

- (void)dealloc {
	activityView = nil;
	statusLabel = nil;
	arrowImage = nil;
	lastUpdatedLabel = nil;
  [super dealloc];
}


@end
