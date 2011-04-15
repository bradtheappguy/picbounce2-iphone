/*
	ACCartItem.h
	The interface definition of properties and methods for the ACCartItem object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
@class ACItem;

@interface ACCartItem : SoapObject
{
	NSString* _Id;
	int _Quantity;
	NSDecimalNumber* _SubTotal;
	ACItem* _Item;
	
}
		
	@property (retain, nonatomic) NSString* Id;
	@property int Quantity;
	@property (retain, nonatomic) NSDecimalNumber* SubTotal;
	@property (retain, nonatomic) ACItem* Item;

	+ (ACCartItem*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
