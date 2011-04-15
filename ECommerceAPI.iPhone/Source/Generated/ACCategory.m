/*
	ACCategory.h
	The implementation of properties and methods for the ACCategory object.
	Generated by SudzC.com
*/
#import "ACCategory.h"

@implementation ACCategory
	@synthesize CategoryId = _CategoryId;
	@synthesize Name = _Name;

	- (id) init
	{
		if(self = [super init])
		{
			self.CategoryId = nil;
			self.Name = nil;

		}
		return self;
	}

	+ (ACCategory*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ACCategory*)[[[ACCategory alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.CategoryId = [Soap getNodeValue: node withName: @"CategoryId"];
			self.Name = [Soap getNodeValue: node withName: @"Name"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"Category"];
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
		if (self.CategoryId != nil) [s appendFormat: @"<CategoryId>%@</CategoryId>", [[self.CategoryId stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ACCategory class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.CategoryId != nil) { [self.CategoryId release]; }
		if(self.Name != nil) { [self.Name release]; }
		[super dealloc];
	}

@end
