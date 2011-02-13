//
//  SKSiteManager.m
//  StackKit
//
//  Created by Alex Rozanski on 12/02/2011.
//  Copyright 2011 Alex Rozanski. All rights reserved.
//

#import "SKSiteManager.h"
#import "SKSiteManager+Private.h"

#import "SKSite.h"
#import "SKSite+Private.h"

#import "SKConstants.h"

#import "SKUser.h"
#import "SKAssociatedUserOperation.h"

#import "JSON.h"

@interface SKSiteManager ()

- (void)_performInitialSetup;
- (void)fetchSites;

@end

static id _manager = nil;

__attribute__((constructor)) void SKSiteManager_construct() {
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    _manager = NSAllocateObject([SKSiteManager class], 0, nil);
    [_manager _performInitialSetup];
    [p drain];
}

__attribute__((destructor)) void SKSiteManager_destruct() {
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    [_manager release], _manager = nil;
    [p drain];
}

@implementation SKSiteManager

+ (id) sharedManager
{
    return [[_manager retain] autorelease];
}

#pragma mark -
#pragma mark Init/Dealloc

- (void)_performInitialSetup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _knownSitesQueue = dispatch_queue_create("com.stackkit.sites", 0);
        _knownSites = [[NSMutableArray alloc] init];
        stackAuthQueue = [[NSOperationQueue alloc] init];
        [stackAuthQueue setMaxConcurrentOperationCount:1];
        
        dispatch_async(_knownSitesQueue, ^{
            [self fetchSites];
        });
    });
}

+ (id) allocWithZone:(NSZone *)zone {
    NSLog(@"you may not allocate an SKSiteManager object");
    return nil;
}

- (void)dealloc {
    dispatch_release(_knownSitesQueue), _knownSitesQueue = nil;
    [_knownSites release], _knownSites = nil;
    [stackAuthQueue cancelAllOperations];
    [stackAuthQueue release], stackAuthQueue = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Loading

- (void)fetchSites {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *sitesDictionary = [self cachedSitesDictionary];
    
    if(!sitesDictionary) {
        NSString * urlString = [NSString stringWithFormat:@"http://stackauth.com/%@/sites", SKAPIVersion];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        NSHTTPURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error == nil && data != nil) {	
            NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            sitesDictionary = [dataString JSONValue];
            [dataString release];
            
            [self cacheSitesWithDictionary:sitesDictionary];
        }
    }
    
    if(sitesDictionary) {
        NSArray * sites = [sitesDictionary objectForKey:@"items"];
        
        for (NSDictionary * siteDictionary in sites) {
            SKSite *thisSite = NSAllocateObject([SKSite class], 0, NULL);
            [thisSite mergeInformationFromDictionary:siteDictionary];
            [_knownSites addObject:thisSite];
            [thisSite release];
        }
    }
	[pool drain];
}

#pragma mark -
#pragma mark Sites

- (NSArray*) knownSites
{
    __block NSArray *sites = nil;
    dispatch_sync(_knownSitesQueue, ^{
        sites = [_knownSites copy]; 
    });
    
    return [sites autorelease]; 
}  

- (SKSite*) siteWithAPIURL:(NSURL *)aURL
{
    NSArray *knownSites = [self knownSites];
    
    NSString * apiHost = [aURL host];
    for (SKSite * aSite in knownSites) {
        if ([[[aSite apiURL] host] isEqual:apiHost]) {
            return aSite;
        }
    }
    
    return nil;
}

- (SKSite *) siteWithName:(NSString *)name {
    NSArray *knownSites = [self knownSites];
    
    for (SKSite * aSite in knownSites) {
        if ([[aSite name] isEqualToString:name]) {
            return aSite;
        }
    }
    
    return nil;
}

- (SKSite*) stackOverflowSite {
    return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"]];
}

- (SKSite*) metaStackOverflowSite {
    return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.meta.stackoverflow.com"]];
}

- (SKSite*) stackAppsSite {
    return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.stackapps.com"]];
}

- (SKSite*) serverFaultSite {
    return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.serverfault.com"]];
}

- (SKSite*) superUserSite {
    return [self siteWithAPIURL:[NSURL URLWithString:@"http://api.superuser.com"]];
}

#pragma mark -
#pragma mark Site Counterparts

- (SKSite*) mainSiteForSite:(SKSite *)aSite
{
    NSString * host = [[aSite apiURL] host];
	NSArray * originalHostComponents = [host componentsSeparatedByString:@"."];
	if ([originalHostComponents containsObject:@"meta"] == NO) { return aSite; }
	
	NSMutableArray * newHostComponents = [originalHostComponents mutableCopy];
	[newHostComponents removeObject:@"meta"];
	
	NSString * qaHost = [newHostComponents componentsJoinedByString:@"."];
	[newHostComponents release];
	
	for (SKSite * potentialSite in [self knownSites]) {
		if ([[[potentialSite apiURL] host] isEqual:qaHost]) {
			return potentialSite;
		}		
	}
	return nil;
}

- (SKSite*) metaSiteForSite:(SKSite *)aSite
{
    //takes an API URL (api.somesite.com) and transforms it into (api.meta.somesite.com)
	//and then looks for a known site that has the same hostname
	
	NSString * host = [[aSite apiURL] host];
	
	NSArray * originalHostComponents = [host componentsSeparatedByString:@"."];
	//if we are a meta site, return ourself
	if ([originalHostComponents containsObject:@"meta"]) { return aSite; }
	
	NSMutableArray * newHostComponents = [originalHostComponents mutableCopy];
	if ([[newHostComponents objectAtIndex:0] isEqual:@"api"]) {
		[newHostComponents insertObject:@"meta" atIndex:1];
	} else {
		[newHostComponents insertObject:@"meta" atIndex:0];
	}
	NSString * metaHost = [newHostComponents componentsJoinedByString:@"."];
	[newHostComponents release];
	
	for (SKSite * potentialSite in [self knownSites]) {
		if ([[[potentialSite apiURL] host] isEqual:metaHost]) {
			return potentialSite;
		}
	}
	
	return nil;
}

- (SKSite*) companionSiteForSite:(SKSite *)aSite
{
    //if this is a meta site, return the QA site (and vice versa)
	if ([[[aSite apiURL] host] rangeOfString:@".meta."].location != NSNotFound) {
		return [self mainSiteForSite:aSite];
	} else {
		return [self metaSiteForSite:aSite];
	}
}

#pragma mark -
#pragma mark Persistence

- (NSString *)applicationSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    
#ifdef StackKitMac
    // alter basePath to point at the App's specific support dir, and not ~/Library/App Support
#endif
    
    NSString *asd = [basePath stringByAppendingPathComponent:@"StackKit"];
    
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:asd isDirectory:&isDir] == NO || isDir == NO) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:asd withIntermediateDirectories:YES attributes:nil error:&error]) {   
            NSLog(@"Error creating application support directory at %@ : %@", asd, error);
        }
    }
    
    return asd;
}

- (NSString*)cachedSitesFilename
{
    return [[self applicationSupportDirectory] stringByAppendingPathComponent:@"sites.db"];
}

- (NSDictionary*)cachedSitesDictionary
{
    //Only re-request the dictionary if it is older than a day (following SO API guidelines)
    NSDictionary *cacheDictionary = [NSDictionary dictionaryWithContentsOfFile:[self cachedSitesFilename]];
    NSDate *cacheDate = [cacheDictionary objectForKey:@"cacheDate"];
    
    NSDateComponents * oneDay = [[NSDateComponents alloc] init];
    [oneDay setDay:1];
    
    NSDate *cacheInvalidationDate = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:cacheDate options:0];
    [oneDay release];
    
    //Return nil if the cache is out of date
    if ([[cacheInvalidationDate laterDate:cacheDate] isEqualToDate:cacheInvalidationDate]) {
        return nil;
    }
    
    return [cacheDictionary objectForKey:@"sites"];
}

- (void)cacheSitesWithDictionary:(NSDictionary*)siteDictionary
{
    NSMutableDictionary *cacheDictionary = [NSMutableDictionary dictionary];
    [cacheDictionary setObject:siteDictionary forKey:@"sites"];
    [cacheDictionary setObject:[NSDate date] forKey:@"cacheDate"];
     
    [cacheDictionary writeToFile:[self cachedSitesFilename] atomically:NO];
}

#pragma mark -
#pragma mark Associated Users

- (void) requestAssociatedUsersForUser:(SKUser *)user completionHandler:(SKRequestHandler)handler {
    if (user == nil) { return; }
    if (handler == nil) { return; }
    
    SKAssociatedUserOperation *op = [[SKAssociatedUserOperation alloc] initWithUser:user handler:handler];
    if (op == nil) { return; }
    
    [stackAuthQueue addOperation:op];
    [op release];
}

@end
