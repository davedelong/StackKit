/** A generic asynchronous operation
 
 A subclass of NSOperation used by all requests to the StackExchange API.
 */

#import <Foundation/Foundation.h>
#import "SKSite.h"

@interface SKOperation : NSOperation {
    SKSite *site;
}

@property (nonatomic, retain) SKSite * site;

- (id) initWithSite:(SKSite *)baseSite;

@end
