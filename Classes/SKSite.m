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

#import "StackKit_Internal.h"
#import "SKSite+Private.h"
#import "SKSite+Caching.h"

NSString * const SKSiteAPIKey = @"key";

@implementation SKSite

@synthesize delegate;
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
	SKFetchRequest * request = [[SKFetchRequest alloc] init];
	[request setEntity:[SKUser class]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, aUserID]];
	NSError * error = nil;
	NSArray * matches = [self executeSynchronousFetchRequest:request error:&error];
	[request release];
	if (error != nil) { return nil; }
	if ([matches count] != 1) { return nil; }
	return [matches objectAtIndex:0];
}

- (NSArray *) executeSynchronousFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error {
	[fetchRequest setSite:self];
	[fetchRequest setDelegate:nil];
	
	NSArray * results = [fetchRequest execute];
	if ([fetchRequest error] && error) {
		*error = [fetchRequest error];
	}
	return results;
}

- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest {
	if (fetchRequest == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidRequest reason:@"fetchRequest cannot be nil" userInfo:nil];
	}
	if([fetchRequest callback] == nil && [fetchRequest delegate] == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidHandler reason:@"SKFetchRequest must have a delegate or callback specified" userInfo:nil];
	}
	else if ([fetchRequest delegate] && [[fetchRequest delegate] conformsToProtocol:@protocol(SKFetchRequestDelegate)] == NO) {
		@throw [NSException exceptionWithName:SKExceptionInvalidHandler reason:@"SKFetchRequest.delegate must conform to <SKFetchRequestDelegate>" userInfo:nil];
	}
	
	if ([fetchRequest delegate] != nil && [fetchRequest callback] == nil) {
		//transform the delegate into an SKCallback:
		SKCallback * callback = [SKCallback callbackWithTarget:[fetchRequest delegate] 
											   successSelector:@selector(fetchRequest:didReturnResults:) 
											   failureSelector:@selector(fetchRequest:didFailWithError:)];
		[fetchRequest setDelegate:nil];
		[fetchRequest setCallback:callback];
	}	
	
	[fetchRequest setSite:self];
	
	NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:fetchRequest selector:@selector(executeAsynchronously) object:nil];
	[requestQueue addOperation:operation];
	[operation release];
}

#ifdef NS_BLOCKS_AVAILABLE
- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest withCompletionHandler:(SKFetchRequestCompletionHandler)handler {
	if (handler == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidHandler reason:@"CompletionHandler cannot be nil" userInfo:nil];
	}
	SKCallback * callback = [SKCallback callbackWithCompletionHandler:handler];
	[fetchRequest setCallback:callback];
	[fetchRequest setDelegate:nil];
	[self executeFetchRequest:fetchRequest];
}
#endif

#pragma mark Site information

- (NSDictionary *) statisticsWithError:(NSError **)error {
	NSDictionary * queryDictionary = [NSDictionary dictionaryWithObject:[self apiKey] forKey:SKSiteAPIKey];
	NSString * statsPath = [NSString stringWithFormat:@"stats?%@", [queryDictionary queryString]];
	
	NSString * statsCall = [[[self apiURL] absoluteString] stringByAppendingPathComponent:statsPath];
	
	NSURL * statsURL = [NSURL URLWithString:statsCall];
	
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[statsURL absoluteURL]];
	NSURLResponse * response = nil;
	
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:error];
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * statistics = [responseString JSONValue];
	
	if ([statistics isKindOfClass:[NSDictionary class]] == NO) { return nil; }
	
	return [[statistics objectForKey:@"statistics"] objectAtIndex:0];
}

- (NSDictionary *) statistics {
	return [self statisticsWithError:nil];
}

- (void) requestStatistics {
	if ([self delegate] == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidHandler reason:@"SKSite.delegate cannot be nil" userInfo:nil];
	}
	
	if ([[self delegate] conformsToProtocol:@protocol(SKSiteDelegate)] == NO) {
		@throw [NSException exceptionWithName:SKExceptionInvalidHandler reason:@"SKSite.delegate must conform to <SKSiteDelegate>" userInfo:nil];
	}
	
	NSInvocationOperation * op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(asynchronousStatistics) object:nil];
	[requestQueue addOperation:op];
	[op release];
}

- (void) asynchronousStatistics {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSError * error = nil;
	NSDictionary * stats = [self statisticsWithError:&error];
	
	[[self delegate] site:self didRetrieveStatistics:stats error:error];
	
	[pool drain];
}

#pragma mark CoreData

- (NSString *)applicationSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"StackKit"];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel) { return managedObjectModel; }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
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
    
	NSString *storeFileName = [NSString stringWithFormat:@"%@.db", [self apiURL]];
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
