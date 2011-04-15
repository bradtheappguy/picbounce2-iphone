/*
	ACCartTotal.h
	The interface definition of properties and methods for the ACCartTotal object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface ACCartTotal : SoapObject
{
	NSDecimalNumber* _ProductSubTotal;
	NSDecimalNumber* _TaxTotal;
	NSDecimalNumber* _ShippingTotal;
	NSDecimalNumber* _Total;
	
}
		
	@property (retain, nonatomic) NSDecimalNumber* ProductSubTotal;
	@property (retain, nonatomic) NSDecimalNumber* TaxTotal;
	@property (retain, nonatomic) NSDecimalNumber* ShippingTotal;
	@property (retain, nonatomic) NSDecimalNumber* Total;

	+ (ACCartTotal*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
