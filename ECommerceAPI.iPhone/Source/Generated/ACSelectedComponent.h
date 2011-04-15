/*
	ACSelectedComponent.h
	The interface definition of properties and methods for the ACSelectedComponent object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
@class ACComponentDimensions;
@class ACItemPrice;

@interface ACSelectedComponent : SoapObject
{
	int _ItemNumber;
	NSString* _Name;
	ACComponentDimensions* _Dimensions;
	ACItemPrice* _Price;
	
}
		
	@property int ItemNumber;
	@property (retain, nonatomic) NSString* Name;
	@property (retain, nonatomic) ACComponentDimensions* Dimensions;
	@property (retain, nonatomic) ACItemPrice* Price;

	+ (ACSelectedComponent*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
