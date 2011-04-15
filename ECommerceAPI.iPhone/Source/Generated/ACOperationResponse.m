/*
	ACOperationResponse.h
	The implementation of properties and methods for the ACOperationResponse object.
	Generated by SudzC.com
*/
#import "ACOperationResponse.h"

@implementation ACOperationResponse
	@synthesize ResponseCode = _ResponseCode;
	@synthesize ResponseMessage = _ResponseMessage;

	- (id) init
	{
		if(self = [super init])
		{
			self.ResponseMessage = nil;

		}
		return self;
	}

	+ (ACOperationResponse*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ACOperationResponse*)[[[ACOperationResponse alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.ResponseCode = [[Soap getNodeValue: node withName: @"ResponseCode"] intValue];
			self.ResponseMessage = [Soap getNodeValue: node withName: @"ResponseMessage"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"OperationResponse"];
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
		[s appendFormat: @"<ResponseCode>%@</ResponseCode>", [NSString stringWithFormat: @"%i", self.ResponseCode]];
		if (self.ResponseMessage != nil) [s appendFormat: @"<ResponseMessage>%@</ResponseMessage>", [[self.ResponseMessage stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ACOperationResponse class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.ResponseMessage != nil) { [self.ResponseMessage release]; }
		[super dealloc];
	}

@end
