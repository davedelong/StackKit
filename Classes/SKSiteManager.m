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

#import "JSON.h"

@implementation SKSiteManager

+ (id)sharedManager
{
    static id _manager = nil;
    if(!_manager) {
        _manager = [[self alloc] init];
    }
    
    return _manager;
}

#pragma mark -
#pragma mark Init/Dealloc

- (id)init
{
    if((self = [super init])) {
        _knownSites = [[NSMutableArray alloc] init];
        [self performSelectorInBackground:@selector(fetchSites) withObject:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [_knownSites release], _knownSites = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Loading

- (void)fetchSites
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[SKSite fetchLock] lock];
	
	
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://stackauth.com/sites"]];
	
	NSHTTPURLResponse * response = nil;
	NSError * error = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (error == nil && data != nil) {		
		NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary * sitesDictionary = [dataString JSONValue];
		[dataString release];
		
		if (sitesDictionary != nil) {
			NSArray * sites = [sitesDictionary objectForKey:@"api_sites"];
			
			for (NSDictionary * siteDictionary in sites) {
				SKSite *thisSite = NSAllocateObject([SKSite class], 0, NULL);
				[thisSite mergeInformationFromDictionary:siteDictionary];
				[_knownSites addObject:thisSite];
				[thisSite release];
			}
		}
	}
	
	[[SKSite fetchLock] unlock];
	[pool drain];

}

#pragma mark -
#pragma mark Sites

- (NSArray*) knownSites
{
    [[SKSite fetchLock] lock];
    NSArray *sites = _knownSites;
    [[SKSite fetchLock] unlock];
    
    return sites; 
}  

- (SKSite*) siteWithAPIURL:(NSURL *)aURL
{
    NSString * apiHost = [aURL host];
    for (SKSite * aSite in [self knownSites]) {
        NSURL * siteAPIURL = [aSite apiURL];
        if ([[siteAPIURL host] isEqual:apiHost]) {
            return aSite;
        }
    }
    
    //only return an SKSite that points to a valid StackAuth site
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
    return [basePath stringByAppendingPathComponent:@"StackKit"];
}

@end
