/*
	ACOrderAttributes.h
	The implementation of properties and methods for the ACOrderAttributes object.
	Generated by SudzC.com
*/
#import "ACOrderAttributes.h"

@implementation ACOrderAttributes
	@synthesize OrderNumber = _OrderNumber;

	- (id) init
	{
		if(self = [super init])
		{
			self.OrderNumber = nil;

		}
		return self;
	}

	+ (ACOrderAttributes*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ACOrderAttributes*)[[[ACOrderAttributes alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.OrderNumber = [Soap getNodeValue: node withName: @"OrderNumber"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"OrderAttributes"];
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
		if (self.OrderNumber != nil) [s appendFormat: @"<OrderNumber>%@</OrderNumber>", [[self.OrderNumber stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ACOrderAttributes class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.OrderNumber != nil) { [self.OrderNumber release]; }
		[super dealloc];
	}

@end
