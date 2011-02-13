// 
//  SKObject.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKObject.h"
#import "SKObject+Private.h"
#import "SKSite+Private.h"
#import "SKSite+Caching.h"
#import "SKFetchOperation.h"
#import "SKFunctions.h"

#pragma mark Private methods
@interface SKObject ()

@property (nonatomic, retain) SKSite * site;

@end

#pragma mark Main Implementation

@implementation SKObject 

@synthesize site;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc_];
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return NSStringFromClass(self);
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) apiResponseDataKey {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) apiResponseUniqueIDKey {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) uniqueIDKey {
    return [self propertyKeyFromAPIAttributeKey:[self apiResponseUniqueIDKey]];
}

+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key {
	NSDictionary * mappings = [self APIAttributeToPropertyMapping];
	if ([mappings objectForKey:key] != nil) {
		return [mappings objectForKey:key];
	}
	return key;
}

+ (id) objectMergedWithDictionary:(NSDictionary *)dictionary inSite:(SKSite *)site {
	//TODO: looking of existing objects?
	SKObject *object = nil;
	
	SKCache *objectIDCache = [site cacheForClass:self];
	
	NSString *uniqueIDKey = [self apiResponseUniqueIDKey];
	if (uniqueIDKey == nil) { return nil; }
	id uniqueID = [dictionary objectForKey:uniqueIDKey];
	if (uniqueID == nil) { return nil; }
	
	NSManagedObjectID *objectID = [objectIDCache objectForKey:uniqueID];
	if (objectID != nil) {
		//attempt to retrieve an object from the cache
		object = (SKObject *)[[site managedObjectContext] existingObjectWithID:objectID error:nil];
	}
	
	if (object == nil) {
		//either the objectID has been discarded or it does not exist
		//attempt to fetch it
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[self entityInManagedObjectContext:[site managedObjectContext]]];
		
		NSDictionary *propertyNameMapping = [self APIAttributeToPropertyMapping];
		NSPredicate *p = [NSPredicate predicateWithFormat:@"%K = %@", [propertyNameMapping objectForKey:uniqueIDKey], uniqueID];
		[request setPredicate:p];
		
		NSError *fetchError = nil;
		NSArray *results = [[site managedObjectContext] executeFetchRequest:request error:&fetchError];
		[request release];
		
		if ([results count] > 0) {
			object = [results objectAtIndex:0];
		}
	}
	
	if (object == nil) {
        object = [self insertInManagedObjectContext:[site managedObjectContext]];
	}
	
    [object setSite:site];
	[objectIDCache setObject:[object objectID] forKey:uniqueID];
	
	[object mergeInformationFromAPIResponseDictionary:dictionary];
	
	return object;
}

- (SKFetchRequest *) mergeRequest {
    return nil;
}

- (void) requestFullMergeWithCompletionHandler:(SKActionBlock)completion {
    SKFetchRequest *mergeRequest = [self mergeRequest];
    
    if (mergeRequest != nil) {
        SKFetchOperation *mergeOperation = [[SKFetchOperation alloc] initWithSite:[self site] fetchRequest:mergeRequest];
        SKActionBlock b = [completion copy];
        SKRequestHandler handler = ^(NSArray * results) {
            b();
        };
        [b release];
        
        [mergeOperation setHandler:handler];
        [[[self site] requestQueue] addOperation:mergeOperation];
        [mergeOperation release];
    } else {
        completion();
    }
}

- (id) transformValueToMerge:(id)value forProperty:(NSString *)property {
    if ([property hasSuffix:@"Date"]) {
        // by convention, Date properties end with "Date" (creationDate, lastAccessDate, etc)
        return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    } else if ([property hasSuffix:@"URL"]) {
        // by conventino, URL properties end with "URL" (websiteURL, etc)
        return [NSURL URLWithString:value];
    }
    return value;
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    NSLog(@"ERROR: unable to transform for -[%@ %@]: %@", NSStringFromClass([self class]), relationship, value);
    return nil;
}

- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary {
    NSEntityDescription *entity = [self entity];
    NSDictionary *properties = [entity propertiesByName];
    NSDictionary *propertyMapping = [[self class] APIAttributeToPropertyMapping];
    
    for (NSString * responseKey in dictionary) {
        NSString *propertyName = [propertyMapping objectForKey:responseKey];
        if (propertyName == nil) { continue; }
        
        id newValue = [dictionary objectForKey:responseKey];
        
        NSPropertyDescription *propertyDescription = [properties objectForKey:propertyName];
        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            // regular attribute.  transform and replace
            newValue = [self transformValueToMerge:newValue forProperty:propertyName];
            if (newValue == nil) { continue; }
            
            [self willChangeValueForKey:propertyName];
            [self setPrimitiveValue:newValue forKey:propertyName];
            [self didChangeValueForKey:propertyName];
            
        } else if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
            // relationship. transform and merge
            NSRelationshipDescription *relationship = (NSRelationshipDescription *)propertyDescription;
            if ([relationship isToMany]) {
                // to-many relationship. the value to transform can be a dictionary or collection
                if ([newValue isKindOfClass:[NSDictionary class]] == NO && SKIsVectorClass(newValue) == NO) {
                    NSLog(@"ERROR: cannot handle non-collection merge information for %@ relationship: %@", propertyName, newValue);
                    continue;
                }
                // transform the dictionary into appropriate objects:
                NSMutableSet *mergingObjects = [NSMutableSet set];
                if (SKIsVectorClass(newValue)) {
                    for (id subValue in newValue) {
                        subValue = [self transformValueToMerge:subValue forRelationship:propertyName];
                        if (subValue == nil) { continue; }
                        [mergingObjects addObject:subValue];
                    }
                } else {
                    id subValue = [self transformValueToMerge:newValue forRelationship:propertyName];
                    [mergingObjects addObject:subValue];
                }
                
                // merge in the objects
                
                [self willChangeValueForKey:propertyName withSetMutation:NSKeyValueUnionSetMutation usingObjects:mergingObjects];
                [[self primitiveValueForKey:propertyName] unionSet:mergingObjects];
                [self didChangeValueForKey:propertyName withSetMutation:NSKeyValueUnionSetMutation usingObjects:mergingObjects];
                
            } else {
                // to-one relationship.  the value to transform must be a dictionary
                if (SKIsVectorClass(newValue)) {
                    NSLog(@"ERROR: cannot handle collection merge information for %@ relationship: %@", propertyName, newValue);
                    continue;
                }
                newValue = [self transformValueToMerge:newValue forRelationship:propertyName];
                
                [self willChangeValueForKey:propertyName];
                [self setPrimitiveValue:newValue forKey:propertyName];
                [self didChangeValueForKey:propertyName];
            }
        }
    }
}

//- (BOOL) isEqual:(id)object {
//    if ([object isKindOfClass:[self class]] == NO) { return NO; }
//    NSString * uniquePropertyName = [[self class] uniqueIDKey];
//    id myUniqueValue = [self valueForKey:uniquePropertyName];
//    id theirUniqueValue = [object valueForKey:uniquePropertyName];
//    
//    return [myUniqueValue isEqual:theirUniqueValue];
//}

#pragma mark -
#pragma mark KVC Compliance

- (id) valueForUndefinedKey:(NSString *)key {
	NSString * newKey = [[self class] propertyKeyFromAPIAttributeKey:key];
	if (newKey != nil && [newKey isEqual:key] == NO) {
		//this is a new key! try again
		return [self valueForKey:newKey];
	}
	//eh, we couldn't find a replacement.  pass it on up the chain
	return [super valueForUndefinedKey:key];
}

@end
