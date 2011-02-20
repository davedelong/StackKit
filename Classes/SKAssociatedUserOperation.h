/** An operation for requesting associated user accounts
 
 A subclass of SKOperation for request the associated accounts of a particular SKUser.
 */

#import <Foundation/Foundation.h>
#import "SKOperation.h"

@class SKUser;

@interface SKAssociatedUserOperation : SKOperation {
    SKUser *baseUser;
    SKRequestHandler handler;
}

@property (nonatomic, copy) SKRequestHandler handler;

- (id) initWithUser:(SKUser *)user handler:(SKRequestHandler)completionHandler;

@end
