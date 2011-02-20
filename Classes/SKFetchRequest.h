/** The primary class for requesting information
 
 A fetch request encapsulates a desired search query against the StackExchange API.  It is executed by an SKSite object.  If an error occurs during execution, then the [SKFetchRequest error] property will return an object indicating what failed.
 */

#import <Foundation/Foundation.h>

@class SKSite;

@interface SKFetchRequest : NSObject {
	Class entity;
	NSSortDescriptor * sortDescriptor;
	NSUInteger fetchLimit;
	NSUInteger fetchOffset;
	NSUInteger fetchTotal;
	NSPredicate * predicate;
	
	NSError * error;
	NSURL * fetchURL;
	
    SKSite *site;
}

@property (assign) Class entity;
@property (retain) NSSortDescriptor * sortDescriptor;
@property (assign) NSUInteger fetchLimit;
@property (assign) NSUInteger fetchOffset;
@property (assign, readonly) NSUInteger fetchTotal;
@property (retain) NSPredicate * predicate;
@property (readonly, retain) NSError * error;

@end
