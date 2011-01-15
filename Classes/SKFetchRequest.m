//
//  SKFetchRequest.m
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
#import <objc/runtime.h>

@implementation SKFetchRequest
@synthesize entity;
@synthesize sortDescriptor;
@synthesize fetchLimit;
@synthesize fetchOffset;
@synthesize fetchTotal;
@synthesize predicate;
@synthesize error;
@synthesize delegate;
@synthesize fetchURL;
@synthesize callback;

NSString * SKErrorResponseKey = @"error";
NSString * SKErrorCodeKey = @"code";
NSString * SKErrorMessageKey = @"message";

NSString * SKFetchTotalKey = @"total";

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super initWithSite:aSite]) {
		fetchLimit = SKPageSizeLimitMax;
		fetchOffset = 0;
	}
	return self;
}

- (id) init {
	return [self initWithSite:nil];
}

- (void) dealloc {
	[fetchTotal release];
	[sortDescriptor release];
	[predicate release];
	[error release];
	[fetchURL release];
	[callback release];
	[super dealloc];
}

+ (NSArray *) validFetchEntities {
	return [NSArray arrayWithObjects:
			[SKUser class],
			[SKUserActivity class],
			[SKTag class], 
			[SKBadge class], 
			[SKQuestion class], 
			[SKAnswer class], 
			[SKComment class], 
			nil];
}

- (NSMutableDictionary *) defaultQueryDictionary {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	[d setObject:[[self site] apiKey] forKey:SKSiteAPIKey];
	
	return d;
}

- (NSURL *) apiCall {
	if ([self site] == nil) { return nil; }
	
	Class fetchEntity = [self entity];
	
	if ([fetchEntity respondsToSelector:@selector(endpoints)] == NO) {
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:nil]];
		return nil;
	}
	
	NSError * requestBuilderError = nil;
	NSURL * builderURL = [SKRequestBuilder URLForFetchRequest:self error:&requestBuilderError];
	NSLog(@"builderURL: %@ (%@)", builderURL, requestBuilderError);

	NSArray * endpoints = [fetchEntity endpoints];

	for (Class endpointClass in endpoints) {
		SKEndpoint * endpoint = [endpointClass endpointForFetchRequest:self];
		if ([endpoint validateFetchRequest]) {
			[self setError:nil];
			return [endpoint APIURLForFetchRequest:self];
		} else {
			[self setError:[endpoint error]];
		}
	}
	
	return nil;
}

- (void) executeAsynchronously {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSArray * results = [self execute];
	
	if ([self error] != nil) {
		//ERROR!
		[[self callback] fetchRequest:self failedWithError:[self error]];
	} else {
		//OK
		[[self callback] fetchRequest:self succeededWithResults:results];
	}
	
	[pool drain];
}

- (NSArray *) execute {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSArray * objects = nil;
	
	NSString * apiKey = [[self site] apiKey];
	if (apiKey == nil) {
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidApplicationPublicKey userInfo:nil]];
		goto cleanup;
	}
	
	//construct our fetch url
	[self setFetchURL:[self apiCall]];
	
	if ([self error] != nil) { goto cleanup; }
	if ([self fetchURL] == nil) { goto cleanup; }
	
	objects = [[self executeFetchRequest] retain];
	
cleanup:
	[pool drain];
	return [objects autorelease];
}

- (NSArray *) executeFetchRequest {
	
	//signal the delegate
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(fetchRequestWillBeginExecuting:)]) {
		[[self delegate] fetchRequestWillBeginExecuting:self];
	}
	
	//execute the GET request
//	NSLog(@"fetching from: %@", [self fetchURL]);
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[self fetchURL]];
	NSURLResponse * response = nil;
	NSError * connectionError = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&connectionError];
	
	//signal the delegate
	if ([self delegate] && [[self delegate] respondsToSelector:@selector(fetchRequestDidFinishExecuting:)]) {
		[[self delegate] fetchRequestDidFinishExecuting:self];
	}
	
	if (connectionError != nil) {
		[self setError:connectionError];
		return nil;
	}
	
	//handle the response
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * responseObjects = [responseString JSONValue];
	if ([responseObjects isKindOfClass:[NSDictionary class]] == NO) {
		[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeUnknownError userInfo:nil]];
		return nil;
	}
	
	fetchTotal = [[responseObjects objectForKey:SKFetchTotalKey] retain];
	
	//check for an error in the response
	NSDictionary * errorDictionary = [responseObjects objectForKey:SKErrorResponseKey];
	if (errorDictionary != nil) {
		//there was an error responding to the request
		NSNumber * errorCode = [errorDictionary objectForKey:SKErrorCodeKey];
		NSString * errorMessage = [errorDictionary objectForKey:SKErrorMessageKey];
		
		NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
		[self setError:[NSError errorWithDomain:SKErrorDomain code:[errorCode integerValue] userInfo:userInfo]];
		return nil;
	}
	
	//pull out the data container
	NSString * dataKey = [[self entity] dataKey];
	id dataObject = [responseObjects objectForKey:dataKey];
	
	NSMutableArray * objects = [[NSMutableArray alloc] init];	
	
	//parse the response into objects
	if ([dataObject isKindOfClass:[NSArray class]]) {
		for (NSDictionary * dataDictionary in dataObject) {
			SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataDictionary];
			[objects addObject:object];
		}
	} else if ([dataObject isKindOfClass:[NSDictionary class]]) {
		SKObject * object = [[self entity] objectWithSite:[self site] dictionaryRepresentation:dataObject];
		[objects addObject:object];
	}
	
	return [objects autorelease];
}

- (void) setFetchLimit:(NSUInteger)newLimit {
	if (newLimit > SKPageSizeLimitMax) {
		newLimit = SKPageSizeLimitMax;
	}
	fetchLimit = newLimit;
}

@end
