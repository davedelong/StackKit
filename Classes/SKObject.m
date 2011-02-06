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
	return nil;
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
		[object setSite:site];
	}
	
	[objectIDCache setObject:[object objectID] forKey:uniqueID];
	
	[object mergeInformationFromAPIResponseDictionary:dictionary];
	
	return object;
}

- (id) willMergeValue:(id)value forProperty:(NSString *)property {
    if ([property hasSuffix:@"Date"]) {
        // by convention, Date properties end with "Date" (creationDate, lastAccessDate, etc)
        return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    } else if ([property hasSuffix:@"URL"]) {
        // by conventino, URL properties end with "URL" (websiteURL, etc)
        return [NSURL URLWithString:value];
    }
    return value;
}

- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary {
    NSEntityDescription *entity = [self entity];
    NSDictionary *properties = [entity propertiesByName];
    NSDictionary *propertyMapping = [[self class] APIAttributeToPropertyMapping];
    
    for (NSString * apiAttribute in propertyMapping) {
        id newValue = [dictionary objectForKey:apiAttribute];
        if (newValue == nil) { continue; }
        
        NSString *propertyName = [propertyMapping objectForKey:apiAttribute];
        newValue = [self willMergeValue:newValue forProperty:propertyName];
        if (newValue == nil) { continue; }
        
        NSPropertyDescription *propertyDescription = [properties objectForKey:propertyName];
        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            [self setValue:newValue forKey:propertyName];
        } else if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
            //TODO: merge in related objects
        }
    }
}

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
