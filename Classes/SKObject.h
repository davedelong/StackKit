/** The base class
 
 This file contains the definition of SKObject, the base class of all objects returned by the StackKit API
 */

#import <CoreData/CoreData.h>
#import "SKDefinitions.h"

@class SKSite;

@interface SKObject : NSManagedObject  
{
    SKSite *site;
}

@property (nonatomic, readonly) SKSite * site;

/**
 request that the object refresh itself from the API site.
 only valid for SKUser, SKQuestion, SKAnswer, and SKComment objects
 **/
- (void) requestFullMergeWithCompletionHandler:(SKActionBlock)completion;

@end



