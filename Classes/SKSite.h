/** The main object used to interact with the API
 
 SKSite is the main object used to interact with the StackExchange API. It is roughly equivalent to an NSManagedObjectContext, in that it is used to execute fetch requests, and all returned objects exist only in the scope of their related SKSite.  This class also handles persisting SKObjects to disk in a SQLite database.  SKSite objects are singletons and cannot be instantiated.  They can be retrieved from the SKSiteManager singleton.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SKObject.h"
#import "SKDefinitions.h"

extern NSString * const SKSiteAPIKey;

@class SKUser;
@class SKFetchRequest;
@class SKSiteStatistics;

@interface SKSite : NSObject {
	NSString * apiKey;
	NSURL * apiURL;
	NSString * name;
	NSURL * siteURL;
	NSURL * logoURL;
	NSURL * iconURL;
	NSString * summary;
	NSMutableArray * aliases;
	NSDate * creationDate;
    NSString *twitterAccount;
    
	SKSiteState state;
	SKColor * linkColor;
	SKColor * tagBackgroundColor;
	SKColor * tagForegroundColor;
	
	NSTimeInterval timeoutInterval;
	NSOperationQueue * requestQueue;
	
	@private
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectModel *managedObjectModel;
	NSMutableDictionary *cache;
}

@property (copy) NSString * apiKey;
@property (readonly) NSURL * apiURL;
@property (readonly) NSString * apiVersion;
@property (readonly) NSArray * aliases;

@property (readonly) NSString * name;
@property (readonly) NSURL * siteURL;
@property (readonly) NSURL * logoURL;
@property (readonly) NSURL * iconURL;
@property (readonly) NSString * summary;
@property (readonly) NSDate *creationDate;
@property (readonly) NSString *twitterAccount;
@property (readonly) SKSiteState state;
@property (readonly) SKColor * linkColor;
@property (readonly) SKColor * tagBackgroundColor;
@property (readonly) SKColor * tagForegroundColor;

@property NSTimeInterval timeoutInterval;

- (SKSite *) mainSite;
- (SKSite *) metaSite;
- (SKSite *) companionSite;

- (BOOL) isEqualToSite:(SKSite*)anotherSite;

- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest withCompletionHandler:(SKRequestHandler)handler;
- (NSArray *) executeSynchronousFetchRequest:(SKFetchRequest *)fetchRequest;

- (SKSiteStatistics *) statistics;
- (void) requestStatisticsWithCompletionHandler:(SKStatisticsHandler)handler;

@end
