/*
	ACAddress.h
	The interface definition of properties and methods for the ACAddress object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
@class ACPersonName;
@class ACPhoneNumber;

@interface ACAddress : SoapObject
{
	ACPersonName* _Name;
	NSString* _CompanyName;
	NSString* _Address1;
	NSString* _Address2;
	NSString* _City;
	NSString* _State;
	NSString* _ZipCode;
	NSString* _County;
	NSString* _Country;
	ACPhoneNumber* _Phone;
	
}
		
	@property (retain, nonatomic) ACPersonName* Name;
	@property (retain, nonatomic) NSString* CompanyName;
	@property (retain, nonatomic) NSString* Address1;
	@property (retain, nonatomic) NSString* Address2;
	@property (retain, nonatomic) NSString* City;
	@property (retain, nonatomic) NSString* State;
	@property (retain, nonatomic) NSString* ZipCode;
	@property (retain, nonatomic) NSString* County;
	@property (retain, nonatomic) NSString* Country;
	@property (retain, nonatomic) ACPhoneNumber* Phone;

	+ (ACAddress*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
