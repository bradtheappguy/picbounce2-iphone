/*
	ACDimensions.h
	The implementation of properties and methods for the ACDimensions object.
	Generated by SudzC.com
*/
#import "ACDimensions.h"

@implementation ACDimensions
	@synthesize Height = _Height;
	@synthesize Width = _Width;
	@synthesize Depth = _Depth;

	- (id) init
	{
		if(self = [super init])
		{

		}
		return self;
	}

	+ (ACDimensions*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ACDimensions*)[[[ACDimensions alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Height = [[Soap getNodeValue: node withName: @"Height"] doubleValue];
			self.Width = [[Soap getNodeValue: node withName: @"Width"] doubleValue];
			self.Depth = [[Soap getNodeValue: node withName: @"Depth"] doubleValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"Dimensions"];
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
		[s appendFormat: @"<Height>%@</Height>", [NSString stringWithFormat: @"%f", self.Height]];
		[s appendFormat: @"<Width>%@</Width>", [NSString stringWithFormat: @"%f", self.Width]];
		[s appendFormat: @"<Depth>%@</Depth>", [NSString stringWithFormat: @"%f", self.Depth]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ACDimensions class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		[super dealloc];
	}

@end
