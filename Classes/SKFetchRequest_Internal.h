//
//  SKFetchRequest_Internal.h
//  StackKit
//
//  Created by Dave DeLong on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKFetchRequest.h>
#import <CoreData/CoreData.h>

@class SKSite;

@interface NSFetchRequest (StackKit)

@property (nonatomic, retain) SKFetchRequest *stackKitFetchRequest;

@end

@interface SKFetchRequest ()

+ (Class)_targetClass;
- (NSFetchRequest *)_generatedFetchRequest;
- (NSURL *)_apiURLWithSite:(SKSite *)site;

@end

@interface SKUserFetchRequest ()

@property (nonatomic, copy) NSDate *minDate;
@property (nonatomic, copy) NSDate *maxDate;
@property (nonatomic, copy) NSString *sortKey;
@property (nonatomic, copy) NSString *nameContains;
@property (nonatomic, copy) NSIndexSet *userIDs;
@property (nonatomic, assign) BOOL ascending;

@end
