//
//  SKSite+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKSite+Private.h"

static NSLock * fetchLock = nil;
NSArray * _skKnownSites = nil;

@implementation SKSite (Private)

+ (void) initialize {
	if (self == [SKSite class]) {
		fetchLock = [[NSLock alloc] init];
		_skKnownSites = [[NSMutableArray alloc] init];
		[self performSelectorInBackground:@selector(fetchSites) withObject:nil];
	}
}

+ (id) allocWithZone:(NSZone *)zone {
	NSLog(@"You may not allocate an SKSite object");
	return nil;
}

+ (void) fetchSites {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[fetchLock lock];
	
	
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
				[(NSMutableArray *)_skKnownSites addObject:thisSite];
				[thisSite release];
			}
		}
	}
	
	[fetchLock unlock];
	[pool drain];
}

#pragma mark -
#pragma mark Init/Dealloc

- (void) mergeInformationFromDicitonary:(NSDictionary *)dictionary {
	name = [[dictionary objectForKey:@"name"] retain];
	logoURL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"logo_url"]];
	
	NSString * apiPath = [dictionary objectForKey:@"api_endpoint"];
	apiURL = [[NSURL alloc] initWithString:[apiPath stringByAppendingFormat:@"/%@", SKAPIVersion]];
	
	siteURL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"site_url"]];
	summary = [[dictionary objectForKey:@"description"] retain];
	iconURL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"icon_url"]];
	aliases = [[NSMutableArray alloc] init];
	NSArray * potentialAliases = [dictionary objectForKey:@"aliases"];
	for (NSString * alias in potentialAliases) {
		[aliases addObject:[NSURL URLWithString:alias]];
	}
	NSDictionary *stylingInfo = [dictionary objectForKey:@"styling"];
	linkColor = [SKColorFromHexString([stylingInfo objectForKey:@"link_color"]) retain];
	tagBackgroundColor = [SKColorFromHexString([stylingInfo objectForKey:@"tag_background_color"]) retain];
	tagForegroundColor = [SKColorFromHexString([stylingInfo objectForKey:@"tag_foreground_color"]) retain];
	
	state = SKSiteStateNormal;
	NSString * stateString = [dictionary objectForKey:@"state"];
	if ([stateString isEqual:@"linked_meta"]) {
		state = SKSiteStateLinkedMeta;
	} else if ([stateString isEqual:@"open_beta"]) {
		state = SKSiteStateOpenBeta;
	} else if ([stateString isEqual:@"closed_beta"]) {
		state = SKSiteStateClosedBeta;
	}
	
	timeoutInterval = 60.0;
	requestQueue = [[NSOperationQueue alloc] init];
	[requestQueue setMaxConcurrentOperationCount:1];
}

- (void) dealloc {
	[apiKey release];
	[name release];
	[logoURL release];
	[apiURL release];
	[siteURL release];
	[summary release];
	[iconURL release];
	[aliases release];
	
	[linkColor release];
	[tagForegroundColor release];
	[tagBackgroundColor release];
	
	[requestQueue cancelAllOperations];
	[requestQueue release];
	
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	[managedObjectContext release];
	
	[super dealloc];
}

@end
