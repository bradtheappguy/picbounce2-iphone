/*
	ACDimensions.h
	The interface definition of properties and methods for the ACDimensions object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface ACDimensions : SoapObject
{
	double _Height;
	double _Width;
	double _Depth;
	
}
		
	@property double Height;
	@property double Width;
	@property double Depth;

	+ (ACDimensions*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
