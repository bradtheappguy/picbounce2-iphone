/*
	ACItemPrice.h
	The implementation of properties and methods for the ACItemPrice object.
	Generated by SudzC.com
*/
#import "ACItemPrice.h"

@implementation ACItemPrice
	@synthesize Price = _Price;
	@synthesize MSRP = _MSRP;
	@synthesize DisplayPrice = _DisplayPrice;
	@synthesize MarkDownPrice = _MarkDownPrice;

	- (id) init
	{
		if(self = [super init])
		{
			self.Price = nil;
			self.MSRP = nil;
			self.DisplayPrice = nil;
			self.MarkDownPrice = nil;

		}
		return self;
	}

	+ (ACItemPrice*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ACItemPrice*)[[[ACItemPrice alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Price = [NSDecimalNumber decimalNumberWithString: [Soap getNodeValue: node withName: @"Price"]];
			self.MSRP = [NSDecimalNumber decimalNumberWithString: [Soap getNodeValue: node withName: @"MSRP"]];
			self.DisplayPrice = [Soap getNodeValue: node withName: @"DisplayPrice"];
			self.MarkDownPrice = [Soap getNodeValue: node withName: @"MarkDownPrice"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ItemPrice"];
	}
  
	- (NSMutableString*) serialize: (NSString*) nodeName
	{
		NSMutableString* s = [[NSMutableString alloc] init];
		[s appendFormat: @"<%@", nodeName];
		[s appendString: [self serializeAttributes]];
		[s appendString: @">"];
		[s appendString: [self serializeElements]];
		[s appendFormat: @"</%@>", nodeName];
		return [s autorelease];
	}
	
	- (NSMutableString*) serializeElements
	{
		NSMutableString* s = [super serializeElements];
		if (self.Price != nil) [s appendFormat: @"<Price>%@</Price>", [NSString stringWithFormat: @"%@", self.Price]];
		if (self.MSRP != nil) [s appendFormat: @"<MSRP>%@</MSRP>", [NSString stringWithFormat: @"%@", self.MSRP]];
		if (self.DisplayPrice != nil) [s appendFormat: @"<DisplayPrice>%@</DisplayPrice>", [[self.DisplayPrice stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.MarkDownPrice != nil) [s appendFormat: @"<MarkDownPrice>%@</MarkDownPrice>", [[self.MarkDownPrice stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ACItemPrice class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Price != nil) { [self.Price release]; }
		if(self.MSRP != nil) { [self.MSRP release]; }
		if(self.DisplayPrice != nil) { [self.DisplayPrice release]; }
		if(self.MarkDownPrice != nil) { [self.MarkDownPrice release]; }
		[super dealloc];
	}

@end
