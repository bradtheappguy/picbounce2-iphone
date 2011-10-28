//
//  NSDictionary+NotNull.h
//  PicBounce2
//
//  Created by Brad Smith on 23/10/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NotNull)
- (id)objectForKeyNotNull:(NSString *)key;
@end
