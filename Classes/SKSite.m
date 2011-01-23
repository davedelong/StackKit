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

NSString * const SKSiteAPIKey = @"key";

NSString * const SKSiteStylingLinkColor = @"link_color";
NSString * const SKSiteStylingTagColor = @"tag_foreground_color";
NSString * const SKSiteStylingTagBackgroundColor = @"tag_background_color";

NSArray * _skKnownSites = nil;
NSString *_defaultAPIKey = nil;

@implementation SKSite

@synthesize delegate;
@synthesize apiKey;
@synthesize apiURL;
@synthesize timeoutInterval;

@synthesize name;
@synthesize siteURL;
@synthesize logoURL;
@synthesize iconURL;
@synthesize summary;
@synthesize state;
@synthesize stylingInformation;

#pragma mark Site Constructors

+ (void) loadSites {
	NSString * stackAuth = [NSString stringWithFormat:@"http://stackauth.com/%@/sites", SKAPIVersion];
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:stackAuth]];
	
	NSHTTPURLResponse * response = nil;
	NSError * error = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (error != nil) { return; }
	if (data == nil) { return; }
	
	NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary * sitesDictionary = [dataString JSONValue];
	[dataString release];
	
	if (sitesDictionary == nil) { return; }
	
	NSArray * sites = [sitesDictionary objectForKey:@"api_sites"];
	
	_skKnownSites = [[NSMutableArray alloc] init];
	for (NSDictionary * siteDictionary in sites) {
		SKSite * thisSite = [[SKSite alloc] initWithSite:nil dictionaryRepresentation:siteDictionary];
		[(NSMutableArray *)_skKnownSites addObject:thisSite];
		[thisSite release];
	}
}

+ (NSArray *) knownSites {
	if (_skKnownSites == nil) {
		[self loadSites];
	}
	return _skKnownSites;
}

+ (void) setDefaultAPIKey:(NSString *)key
{
	NSString *newKey = [key copy];
	[_defaultAPIKey release];
	_defaultAPIKey = newKey;
	
	//Update all the cached sites to use the new default key
	for(SKSite *theSite in _skKnownSites) {
		[theSite setApiKey:_defaultAPIKey];
	}
}

#pragma mark -

+ (id) siteWithAPIURL:(NSURL *)aURL APIKey:(NSString *)key {
	NSString * apiHost = [aURL host];
	for (SKSite * aSite in [[self class] knownSites]) {
		NSURL * siteAPIURL = [aSite apiURL];
		if ([[siteAPIURL host] isEqual:apiHost]) {
			if(!key) {
				return aSite;
			}
			else {
				SKSite *customSite = [aSite copy];
				[customSite setApiKey:key];
				
				return [customSite autorelease];
			}
		}
	}
	
	//for some reason, StackAuth doesn't know about this site
	//build an SKSite anyway, and if it fails, it fails
	NSDictionary * tempInfo = [NSDictionary dictionaryWithObject:[aURL absoluteString] forKey:@"api_endpoint"];
	return [[[self alloc] initWithSite:nil dictionaryRepresentation:tempInfo] autorelease];
}

+ (id) siteWithAPIURL:(NSURL *)aURL {
	return [[self class] siteWithAPIURL:aURL APIKey:nil];
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
#pragma mark Init/Dealloc

- (id) initWithSite:(SKSite *)aSite apiKey:(NSString*)key dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:nil]) {
		[self setApiKey:key];
		
		name = [[dictionary objectForKey:@"name"] retain];
		logoURL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"logo_url"]];
		NSString * apiPath = [dictionary objectForKey:@"api_endpoint"];
		apiURL = [[NSURL alloc] initWithString:[apiPath stringByAppendingFormat:@"/%@", SKAPIVersion]];
		siteURL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"site_url"]];
		iconURL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"icon_url"]];
		summary = [[dictionary objectForKey:@"description"] retain];
		
		stylingInformation = [[NSMutableDictionary alloc] init];
		NSDictionary * styleDict = [dictionary objectForKey:@"styling"];
		for (NSString * key in styleDict) {
			[(NSMutableDictionary *)stylingInformation setObject:SKColorFromHexString([styleDict objectForKey:key]) forKey:key];
		}
		
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
	return self;	
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	NSString *key = SKFrameworkAPIKey;
	if(_defaultAPIKey) {
		key = _defaultAPIKey;
	}
	
	return [self initWithSite:aSite apiKey:key dictionaryRepresentation:dictionary];
}

- (void) dealloc {
	[apiKey release];
	[name release];
	[logoURL release];
	[apiURL release];
	[siteURL release];
	[iconURL release];
	[summary release];
	[stylingInformation release];
	
	[requestQueue cancelAllOperations];
	[requestQueue release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (SKSite *) site {
	return [[self retain] autorelease];
}

- (NSString *) apiVersion {
	return SKAPIVersion;
}

- (SKSite *) qaSite {
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
		return [self qaSite];
	} else {
		return [self metaSite];
	}
}

/**
 #pragma mark -
 #pragma mark Object Caching
 
 - (void) cacheUser:(SKUser *)newUser {
 [cachedUsers setObject:newUser forKey:[newUser userID]];
 }
 
 - (void) cacheTag:(SKTag *)newTag {
 [cachedTags setObject:newTag forKey:[newTag name]];
 }
 
 - (void) cachePost:(SKPost *)newPost {
 [cachedPosts setObject:newPost forKey:[newPost postID]];
 }
 
 - (void) cacheBadge:(SKBadge *)newBadge {
 [cachedBadges setObject:newBadge forKey:[newBadge ID]];
 }
 **/

#pragma mark -
#pragma mark Misc

- (BOOL) isEqual:(id)anotherObject
{
	if ([anotherObject isKindOfClass:[self class]] == NO) { return NO; }
	return [self isEqualToSite:anotherObject];
}

- (BOOL) isEqualToSite:(SKSite*)anotherSite
{
	//Sites are equal if:
	//1. Their API keys are equal
	//2. Their API URLs are equal
	if([[self apiKey] isEqual:[anotherSite apiKey]]&&[[self apiURL] isEqual:[anotherSite apiURL]]) {
		return YES;
	}
	
	return NO;
}

- (id) copyWithZone:(NSZone *)zone
{
	SKSite *newSite = [[[self class] allocWithZone:zone] initWithSite:nil dictionaryRepresentation:nil];

	[newSite setApiKey:[self apiKey]];
	[newSite setApiURL:[self apiURL]];
	[newSite setName:[self name]];
	[newSite setSiteURL:[self siteURL]];
	[newSite setLogoURL:[self logoURL]];
	[newSite setIconURL:[self iconURL]];
	[newSite setSummary:[self summary]];
	[newSite setState:[self state]];
	[newSite setStylingInformation:[self stylingInformation]];
	
	return newSite;
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

@end
