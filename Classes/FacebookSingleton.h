//
//  FacebookSingleton.h
//  PicBounce2
//
//  Created by BradSmith on 4/28/11.
//  Copyright 2011 Clixtr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@interface FacebookSingleton : Facebook {
    
}

+ (Facebook *) sharedFacebook;

@end
