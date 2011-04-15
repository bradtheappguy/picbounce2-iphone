/*
	ACGalleryItem.h
	The interface definition of properties and methods for the ACGalleryItem object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
@class ACItem;

@interface ACGalleryItem : SoapObject
{
	NSString* _GalleryItemId;
	ACItem* _Item;
	
}
		
	@property (retain, nonatomic) NSString* GalleryItemId;
	@property (retain, nonatomic) ACItem* Item;

	+ (ACGalleryItem*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
