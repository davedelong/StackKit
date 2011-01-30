//
//  SKObject+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKObject+Private.h"
#import "SKSite+Private.h"
#import "SKSite+Caching.h"

@implementation SKObject (Private)
@dynamic site;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) dataKey {
	NSAssert(NO, ([NSString stringWithFormat:@"+[%@ %@] must be overridden", NSStringFromClass(self), NSStringFromSelector(_cmd)]));
	return nil;
}

+ (NSString *) uniqueIDKey {
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
	
	NSCache *objectIDCache = [site cacheForClass:self];
	
	NSString *uniqueIDKey = [self uniqueIDKey];
	if (uniqueIDKey == nil) { return nil; }
	id uniqueID = [dictionary objectForKey:uniqueIDKey];
	if (uniqueID == nil) { return nil; }
	
	NSManagedObjectID *objectID = [objectIDCache objectForKey:uniqueID];
	if (objectID != nil) {
		//attempt to retrieve an object from the cache
		object = (SKObject *)[[site managedObjectContext] existingObjectWithID:objectID error:nil];
		
		if ([object isFault]) {
			object = nil;
		}
	}
	
	if (object == nil) {
		//either the objectID has been discarded or it does not exist
		//attempt to fetch it
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:[NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:[site managedObjectContext]]];
		
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
		object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[site managedObjectContext]];
		[object setSite:site];
		NSError *saveError = nil;
		[[site managedObjectContext] save:&saveError];
	}
	
	[objectIDCache setObject:[object objectID] forKey:uniqueID];
	
	[object mergeInformationFromDictionary:dictionary];
	
	return object;
}

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {
	return;
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
