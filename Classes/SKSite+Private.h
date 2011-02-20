/** Private SKSite functionality
 
 Private methods on SKSite available for use interally.
 */

#import <Foundation/Foundation.h>
#import "SKSite.h"

@interface SKSite ()

- (NSManagedObjectContext *) managedObjectContext;
- (NSOperationQueue *) requestQueue;

@end

@interface SKSite (Private)

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary;

@end

