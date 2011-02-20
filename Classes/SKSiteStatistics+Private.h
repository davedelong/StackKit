/** Private SKSiteStatistics functionality
 
 Private methods for use internally.
 */

#import <Foundation/Foundation.h>


@interface SKSiteStatistics ()

+ (id)statsForSite:(SKSite*)site withResponseDictionary:(NSDictionary*)responseDictionary;
- (id)initWithSite:(SKSite*)site responseDictionary:(NSDictionary*)responseDictionary;

@end
