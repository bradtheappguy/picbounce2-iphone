//
//  NSMutableArray+Soap.m
//  SudzCExamples
//
//  Created by Jason Kichline on 12/14/10.
//  Copyright 2010 andCulture. All rights reserved.
//

#import "NSMutableArray+Soap.h"
#import "Soap.h"

@implementation NSMutableArray (Soap)

+(NSMutableArray*)newWithNode: (CXMLNode*) node {
	return [[[self alloc] initWithNode:node] autorelease];
}

-(id)initWithNode:(CXMLNode*)node {
	if(self = [self init]) {
		for(CXMLNode* child in [node children]) {
			[self addObject:[Soap deserialize:child]];
		}
	}
	return self;
}

-(id)object { return self; }

+ (NSMutableString*) serialize: (NSArray*) array {
	return [Soap serialize:array];
}

@end
