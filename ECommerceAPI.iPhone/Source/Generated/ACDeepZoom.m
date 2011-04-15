/*
	ACDeepZoom.h
	The implementation of properties and methods for the ACDeepZoom object.
	Generated by SudzC.com
*/
#import "ACDeepZoom.h"

@implementation ACDeepZoom
	@synthesize IsEnabled = _IsEnabled;
	@synthesize TileImageFolder = _TileImageFolder;

	- (id) init
	{
		if(self = [super init])
		{
			self.TileImageFolder = nil;

		}
		return self;
	}

	+ (ACDeepZoom*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (ACDeepZoom*)[[[ACDeepZoom alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.IsEnabled = [[Soap getNodeValue: node withName: @"IsEnabled"] boolValue];
			self.TileImageFolder = [Soap getNodeValue: node withName: @"TileImageFolder"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"DeepZoom"];
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
		[s appendFormat: @"<IsEnabled>%@</IsEnabled>", (self.IsEnabled)?@"true":@"false"];
		if (self.TileImageFolder != nil) [s appendFormat: @"<TileImageFolder>%@</TileImageFolder>", [[self.TileImageFolder stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ACDeepZoom class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.TileImageFolder != nil) { [self.TileImageFolder release]; }
		[super dealloc];
	}

@end
