//
//  SKObject.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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



