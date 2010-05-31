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

NSString * SKSiteAPIKey = @"key";

@implementation SKSite

@synthesize apiKey;
@synthesize apiURL;
@synthesize apiVersion;
@synthesize timeoutInterval;

+ (id) stackoverflowSite {
	NSString * key = [NSString stringWithContentsOfFile:@"consumerKey.txt" encoding:NSUTF8StringEncoding error:nil];
	if (key == nil) { return nil; }
	return [[[self alloc] initWithAPIURL:[NSURL URLWithString:@"http://api.stackoverflow.com"] APIKey:key] autorelease];
}

#pragma mark -
#pragma mark Init/Dealloc

- (id) initWithAPIURL:(NSURL *)aURL APIKey:(NSString*)key {
	if (self = [super initWithSite:nil]) {
		NSString * urlPath = [[aURL path] stringByAppendingPathComponent:SKAPIVersion];
		apiURL = [[NSURL alloc] initWithString:urlPath relativeToURL:aURL];
		apiKey = [key copy];
		
		timeoutInterval = 60.0;
		requestQueue = [[NSOperationQueue alloc] init];
		[requestQueue setMaxConcurrentOperationCount:1];
	}
	return self;
}

- (void) dealloc {
	[apiURL release];
	[apiKey release];
	
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
	if ([fetchRequest delegate] == nil) {
		@throw [NSException exceptionWithName:SKExceptionInvalidDelegate reason:@"SKFetchRequest.delegate cannot be nil" userInfo:nil];
	}
	if ([[fetchRequest delegate] conformsToProtocol:@protocol(SKFetchRequestDelegate)] == NO) {
		@throw [NSException exceptionWithName:SKExceptionInvalidDelegate reason:@"SKFetchRequest.delegate must conform to <SKFetchRequestDelegate>" userInfo:nil];
	}
	
	NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:fetchRequest selector:@selector(executeAsynchronously) object:nil];
	[requestQueue addOperation:operation];
	[operation release];
}

#pragma mark Site information

- (NSDictionary *) statistics {
	NSDictionary * queryDictionary = [NSDictionary dictionaryWithObject:[self apiKey] forKey:SKSiteAPIKey];
	NSString * statsPath = [NSString stringWithFormat:@"stats?%@", [queryDictionary queryString]];
	
	NSString * statsCall = [[[self apiURL] absoluteString] stringByAppendingPathComponent:statsPath];
	
	NSURL * statsURL = [NSURL URLWithString:statsCall];
	
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[statsURL absoluteURL]];
	NSURLResponse * response = nil;
	
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * statistics = [responseString JSONValue];
	
	assert([statistics isKindOfClass:[NSDictionary class]]);
	assert([[statistics allKeys] count] == 1);
	
	return [[statistics objectForKey:@"statistics"] objectAtIndex:0];
}

@end
