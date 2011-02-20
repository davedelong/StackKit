/** Private SKSiteManager functionality
 
 Private methods for use internally.
 */

#import "SKSiteManager.h"

@interface SKSiteManager ()

- (SKSite *) siteWithName:(NSString *)name;

- (SKSite*)metaSiteForSite:(SKSite*)aSite;
- (SKSite*)mainSiteForSite:(SKSite*)aSite;
- (SKSite*)companionSiteForSite:(SKSite*)aSite;

- (NSString *)applicationSupportDirectory;

@end