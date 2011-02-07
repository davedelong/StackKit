//
//  SKObject+Private.h
//  StackKit
//
//  Created by Dave DeLong on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@interface SKObject ()

+ (NSString*)entityName;
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;

+ (id) objectMergedWithDictionary:(NSDictionary *)dictionary inSite:(SKSite *)site;
- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary;

// used in valueForKey:
+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key;

#pragma mark -
#pragma mark Subclass Overrides
// maps an API response key to the name of an object property
+ (NSDictionary *) APIAttributeToPropertyMapping;

// the key under which response data is found
+ (NSString *) apiResponseDataKey;

// the key by which response data is uniquely identified
+ (NSString *) apiResponseUniqueIDKey;

#pragma mark Merging

// allows subclasses to transform merge data to a different type
// base implementation returns `value`, unless `property` ends with `Date` or `URL`
// in those cases, the value is transformed to an `NSDate` or `NSURL`
- (id) transformValueToMerge:(id)value forProperty:(NSString *)property;

// allows subclasses to transform merge data into a related object
// base implementation logs an error and returns nil
- (id) transformValueToMerge:(id)value forRelationship:(NSString *)relationship;

@end
