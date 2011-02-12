//
//  SKSite.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKSite.h"
#import "SKSite+Private.h"
#import "SKSite+Caching.h"

#import "SKConstants.h"
#import "SKFetchRequest.h"
#import "SKFetchRequest+Private.h"
#import "SKLocalFetchRequest.h"
#import "SKFetchRequest+Private.h"
#import "JSON.h"

#import "NSDictionary+SKAdditions.h"

#import "SKFetchOperation.h"
#import "SKStatisticsOperation.h"

NSString * const SKSiteAPIKey = @"key";

@implementation SKSite

@synthesize apiKey;
@synthesize apiURL;
@synthesize timeoutInterval;

@synthesize name;
@synthesize siteURL;
@synthesize logoURL;
@synthesize iconURL;
@synthesize aliases;
@synthesize summary;
@synthesize state;
@synthesize linkColor;
@synthesize tagForegroundColor, tagBackgroundColor;

#pragma mark Site Constructors

+ (NSArray *) knownSites {
	[fetchLock lock];
	NSArray *sites = _skKnownSites;
	[fetchLock unlock];
	return sites;
}

#pragma mark -

+ (id) siteWithAPIURL:(NSURL *)aURL {
	NSString * apiHost = [aURL host];
	for (SKSite * aSite in [[self class] knownSites]) {
		NSURL * siteAPIURL = [aSite apiURL];
		if ([[siteAPIURL host] isEqual:apiHost]) {
			return aSite;
		}
	}
	
	//only return an SKSite that points to a valid StackAuth site
	return nil;
}

+ (id) stackOverflowSite {
	return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"]];
}

+ (id) metaStackOverflowSite {
	return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.meta.stackoverflow.com"]];
}

+ (id) stackAppsSite {
	return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.stackapps.com"]];
}

+ (id) serverFaultSite {
	return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.serverfault.com"]];
}

+ (id) superUserSite {
	return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.superuser.com"]];
}

#pragma mark -
#pragma mark Accessors

- (NSString *) apiVersion {
	return SKAPIVersion;
}

- (SKSite *) mainSite {
	NSString * host = [[self apiURL] host];
	NSArray * originalHostComponents = [host componentsSeparatedByString:@"."];
	if ([originalHostComponents containsObject:@"meta"] == NO) { return self; }
	
	NSMutableArray * newHostComponents = [originalHostComponents mutableCopy];
	[newHostComponents removeObject:@"meta"];
	
	NSString * qaHost = [newHostComponents componentsJoinedByString:@"."];
	[newHostComponents release];
	
	for (SKSite * potentialSite in [[self class] knownSites]) {
		if ([[[potentialSite apiURL] host] isEqual:qaHost]) {
			return potentialSite;
		}		
	}
	return nil;
}

- (SKSite *) metaSite {
	//takes an API URL (api.somesite.com) and transforms it into (api.meta.somesite.com)
	//and then looks for a known site that has the same hostname
	
	NSString * host = [[self apiURL] host];
	
	NSArray * originalHostComponents = [host componentsSeparatedByString:@"."];
	//if we are a meta site, return ourself
	if ([originalHostComponents containsObject:@"meta"]) { return self; }
	
	NSMutableArray * newHostComponents = [originalHostComponents mutableCopy];
	if ([[newHostComponents objectAtIndex:0] isEqual:@"api"]) {
		[newHostComponents insertObject:@"meta" atIndex:1];
	} else {
		[newHostComponents insertObject:@"meta" atIndex:0];
	}
	NSString * metaHost = [newHostComponents componentsJoinedByString:@"."];
	[newHostComponents release];
	
	for (SKSite * potentialSite in [[self class] knownSites]) {
		if ([[[potentialSite apiURL] host] isEqual:metaHost]) {
			return potentialSite;
		}
	}
	
	return nil;
}

- (SKSite *) companionSite {
	//if this is a meta site, return the QA site (and vice versa)
	if ([[[self apiURL] host] rangeOfString:@".meta."].location != NSNotFound) {
		return [self mainSite];
	} else {
		return [self metaSite];
	}
}

#pragma mark -
#pragma mark Misc

- (BOOL) isEqual:(id)anotherObject
{
	if ([anotherObject isKindOfClass:[self class]] == NO) { return NO; }
	return [self isEqualToSite:anotherObject];
}

- (BOOL) isEqualToSite:(SKSite*)anotherSite
{
	//Sites are equal if their api urls are equal
	return [[self apiURL] isEqual:[anotherSite apiURL]];
}

#pragma mark -
#pragma mark Fetch Requests

- (SKUser *) userWithID:(NSNumber *)aUserID {
	SKLocalFetchRequest * request = [[SKLocalFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"userID = %@", aUserID]];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *coreDataRequest = [request coreDataFetchRequestForManagedObjectContext:context];
    [request release];
    
    NSError *error = nil;
    [context lock];
    NSArray *objects = [context executeFetchRequest:coreDataRequest error:&error];
    [context unlock];
    
    if (error != nil || [objects count] == 0) {
        return nil;
    }
    
    return [objects objectAtIndex:0];
}

- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest withCompletionHandler:(SKFetchRequestHandler)handler {
	if (handler == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidHandler reason:@"CompletionHandler cannot be nil" userInfo:nil];
	}
	if (fetchRequest == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidHandler reason:@"fetchRequest cannot be nil" userInfo:nil];
	}
    
    Class operationClass = [[fetchRequest class] operationClass];
    SKFetchOperation *op = [[operationClass alloc] initWithSite:self fetchRequest:fetchRequest];
    [op setHandler:handler];
    [requestQueue addOperation:op];
    [op release];
}

- (NSArray *) executeSynchronousFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error {
    __block NSArray *returnResults = nil;
    SKFetchRequestHandler b = ^(NSArray *results) {
        returnResults = [results retain];
    };
    
    Class operationClass = [[fetchRequest class] operationClass];
    SKFetchOperation *op = [[operationClass alloc] initWithSite:self fetchRequest:fetchRequest];
    [op setHandler:b];
    [requestQueue addOperation:op];
    
    [op waitUntilFinished];
    
    [op release];
    
    return [returnResults autorelease];
}

#pragma mark Site information

- (void)requestStatisticsWithCompletionHandler:(SKStatisticsHandler)handler {
    if (handler == nil) {
        [NSException raise:NSInvalidArgumentException format:@"handler must not be nil"];
    }
    
    SKStatisticsOperation *op = [[SKStatisticsOperation alloc] initWithSite:self completionHandler:handler];
    [requestQueue addOperation:op];
    [op release];
}

#pragma mark CoreData

- (NSString *)applicationSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
#ifdef StackKitMac
    // alter basePath to point at the App's specific support dir, and not ~/Library/App Support
#endif
    return [basePath stringByAppendingPathComponent:@"StackKit"];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel) { return managedObjectModel; }
    NSArray *bundles = [NSArray arrayWithObject:[NSBundle bundleForClass:[SKSite class]]];
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:bundles] retain];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
    if (persistentStoreCoordinator) { return persistentStoreCoordinator; }
	
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSAssert(NO, @"Managed object model is nil");
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            return nil;
		}
    }
    
	NSString *storeFileName = [NSString stringWithFormat:@"%@.db", [[self apiURL] host]];
    NSURL *url = [NSURL fileURLWithPath:[applicationSupportDirectory stringByAppendingPathComponent:storeFileName]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
												  configuration:nil 
															URL:url 
														options:nil 
														  error:&error]){
		NSLog(@"Error creating persistent store: %@", error);
        [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
        return nil;
    }    
	
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext) return managedObjectContext;
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
		NSLog(@"FAILED TO INITIALIZE STORE");
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSave:) name:NSManagedObjectContextWillSaveNotification object:managedObjectContext];
	
    return managedObjectContext;
}

- (void) contextWillSave:(NSNotification *)notification {
	NSMutableArray *objectIDs = [NSMutableArray array];
	for (NSString *entityName in cache) {
		SKCache *entityCache = [cache objectForKey:entityName];
		[objectIDs addObjectsFromArray:[entityCache allObjects]];
	}
	[objectIDs filterUsingPredicate:[NSPredicate predicateWithFormat:@"isTemporaryID = YES"]];
	
	NSError *error = nil;
	[[self managedObjectContext] obtainPermanentIDsForObjects:objectIDs error:&error];
	if (error != nil) {
		NSLog(@"error retrieving permanent ids: %@", error);
	}
}

@end
