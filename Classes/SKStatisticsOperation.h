/** Statistics Requesting
 
 An SKOperation subclass for requesting statistics about an SKSite.
 */

#import <Foundation/Foundation.h>
#import "SKDefinitions.h"
#import "SKOperation.h"

@interface SKStatisticsOperation : SKOperation {
    SKStatisticsHandler handler;
}

@property (nonatomic, copy) SKStatisticsHandler handler;

- (id) initWithSite:(SKSite *)baseSite completionHandler:(SKStatisticsHandler)aHandler;

@end
