/** SKSite Caching functionality
 
 A method on SKSite for accessing the cache of a specific kind of SKObject.
 */

#import <Foundation/Foundation.h>
#import "SKSite.h"
#import "SKCache.h"

@interface SKSite (Caching)

- (SKCache *) cacheForClass:(Class)aClass;

@end
