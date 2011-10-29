//
//  PBHTTPRequest.h
//  PicBounce2
//
//  Created by Brad Smith on 21/09/2011.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

/*
 This is a simple subclass of ASIHTTPRequest that we can use appwide without having to worry
 about setting properties on each instance of a request.
*/

#import "ASIHTTPRequest.h"

@class ASIFormDataRequest;

@interface PBHTTPRequest : ASIHTTPRequest

+(ASIFormDataRequest *)  formDataRequestWithURL:(NSURL *)URL;

@end
