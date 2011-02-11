//
//  SKObject.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SKSite;

@interface SKObject : NSManagedObject  
{
    SKSite *site;
}

@property (nonatomic, retain, readonly) SKSite * site;

@end



