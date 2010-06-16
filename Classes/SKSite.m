//
//  SKSite.m
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
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

@implementation SKSite

@synthesize delegate;
@synthesize APIKey;
@synthesize APIURL;
@synthesize timeoutInterval;

+ (id) stackoverflowSite {
	return [[[self alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"] APIKey:@"hqh1uqA-AkeM48lxWWPeWA"] autorelease];
}

#pragma mark -
#pragma mark Init/Dealloc

- (id) initWithAPIURL:(NSURL *)aURL APIKey:(NSString*)key {
	if (self = [super initWithSite:nil]) {
		NSString * urlPath = [[aURL path] stringByAppendingPathComponent:SKAPIVersion];
		APIURL = [[NSURL alloc] initWithString:urlPath relativeToURL:aURL];
		[self setAPIKey:key];
		
		timeoutInterval = 60.0;
		requestQueue = [[NSOperationQueue alloc] init];
		[requestQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

- (void) dealloc {
	[APIURL release];
	[APIKey release];
	
	[requestQueue cancelAllOperations];
	[requestQueue release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (SKSite *) site {
	return [[self retain] autorelease];
}

- (NSString *) APIVersion {
	return SKAPIVersion;
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
	
	NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:fetchRequest selector:@selector(executeAsynchronously) object:nil];
	[requestQueue addOperation:operation];
	[operation release];
}

#ifdef NS_BLOCKS_AVAILABLE
- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest withCompletionHandler:(SKFetchRequestCompletionHandler)handler {
	SKCallback * callback = [SKCallback callbackWithCompletionHandler:handler];
	[fetchRequest setCallback:callback];
	[fetchRequest setDelegate:nil];
	[self executeFetchRequest:fetchRequest];
}
#endif

#pragma mark Site information

- (NSDictionary *) statisticsWithError:(NSError **)error {
	NSDictionary * queryDictionary = [NSDictionary dictionaryWithObject:[self APIKey] forKey:SKSiteAPIKey];
	NSString * statsPath = [NSString stringWithFormat:@"stats?%@", [queryDictionary queryString]];
	
	NSString * statsCall = [[[self APIURL] absoluteString] stringByAppendingPathComponent:statsPath];
	
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
	
	[pool release];
}

@end
