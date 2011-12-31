//
//  SKStackExchangeStore.h
//  StackKit
//
//  Created by Jacob Relkin on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * SKStoreType(void);

@class SKSite;

@interface SKStackExchangeStore : NSIncrementalStore

@property (nonatomic, weak) SKSite *site;

@end
