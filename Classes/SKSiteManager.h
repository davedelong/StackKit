/** Container class for all known SKSite objects.
 
 This is the class by which you can retrieve an SKSite object.  It is roughly equivalent in purpose to the http://stackauth.com domain.  The SKSiteManager is also the means by which you can retrieve a user's associated accounts across the entire StackExchange network.
 */

#import <Foundation/Foundation.h>
#import "SKDefinitions.h"

@class SKSite;
@class SKUser;

@interface SKSiteManager : NSObject {
    dispatch_queue_t _knownSitesQueue;
    NSMutableArray *_knownSites;
    NSOperationQueue *stackAuthQueue;
}

+ (id)sharedManager;

- (NSArray *) knownSites;

- (SKSite*) siteWithAPIURL:(NSURL *)aURL;

- (SKSite*) stackOverflowSite;
- (SKSite*) metaStackOverflowSite;
- (SKSite*) stackAppsSite;
- (SKSite*) serverFaultSite;
- (SKSite*) superUserSite;

- (void) requestAssociatedUsersForUser:(SKUser *)user completionHandler:(SKRequestHandler)handler;

@end
