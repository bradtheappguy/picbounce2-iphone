/*
	ACItemResponse.h
	The implementation of properties and methods for the ACItemResponse object.
	Generated by SudzC.com
*/
#import "ACItemResponse.h"

#import "ACOperationResponse.h"
#import "ACArrayOfItem.h"
@implementation ACItemResponse
	@synthesize OperationResponse = _OperationResponse;
	@synthesize Items = _Items;

	- (id) init
	{
		if(self = [super init])
		{
			self.OperationResponse = nil; // [[ACOperationResponse alloc] init];
			self.Items = [[[NSMutableArray alloc] init] autorelease];

		}
		return self;
	}

	+ (ACItemResponse*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ACItemResponse*)[[[ACItemResponse alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.OperationResponse = [[ACOperationResponse newWithNode: [Soap getNode: node withName: @"OperationResponse"]] object];
			self.Items = [[ACArrayOfItem newWithNode: [Soap getNode: node withName: @"Items"]] object];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ItemResponse"];
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
		if (self.OperationResponse != nil) [s appendString: [self.OperationResponse serialize: @"OperationResponse"]];
		if (self.Items != nil && self.Items.count > 0) {
			[s appendFormat: @"<Items>%@</Items>", [ACArrayOfItem serialize: self.Items]];
		} else {
			[s appendString: @"<Items/>"];
		}

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ACItemResponse class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.OperationResponse != nil) { [self.OperationResponse release]; }
		if(self.Items != nil) { [self.Items release]; }
		[super dealloc];
	}

@end
