/** An operation for accessing the SE API
 
 This operation is for executing a remote request against the StackExchange API.  It will lock the -[SKSite managedObjectContext].
 */

#import <Foundation/Foundation.h>
#import "SKOperation.h"
#import "SKDefinitions.h"

@class SKFetchRequest;

@interface SKFetchOperation : SKOperation {
    SKFetchRequest *request;
    SKRequestHandler handler;
    SKActionBlock priorHandler;
    SKActionBlock afterHandler;
    NSError *error;
}

@property (nonatomic, copy) SKRequestHandler handler;
@property (nonatomic, copy) SKActionBlock priorHandler;
@property (nonatomic, copy) SKActionBlock afterHandler;
@property (nonatomic, retain) NSError *error;

- (id) initWithSite:(SKSite *)baseSite fetchRequest:(SKFetchRequest *)aRequest;

@end
