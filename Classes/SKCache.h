/** An object for caching objects
 
 This is a wrapper around NSCache.  It adds the ability to request all objects in the cache.
 */

#import <Foundation/Foundation.h>


@interface SKCache : NSObject <NSCacheDelegate> {
	NSCache *cache;
	NSMutableSet *objects;
}

- (id) init;
- (void) setObject:(id)object forKey:(id)key;
- (void) removeObjectForKey:(id)key;
- (id) objectForKey:(id)key;
- (NSArray *) allObjects;

@end
