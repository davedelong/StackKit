//
//  SKFetchRequest.m
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
#import "SKObject+Private.h"
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

- (id) init {
	self = [super init];
	if (self) {
		fetchLimit = SKPageSizeLimitMax;
		fetchOffset = 0;
	}
	return self;
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

- (NSMutableDictionary *) defaultQueryDictionary {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	[d setObject:[[self site] apiKey] forKey:SKSiteAPIKey];
	
	return d;
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
	NSError * requestBuilderError = nil;
	NSURL * builderURL = [SKRequestBuilder URLForFetchRequest:self error:&requestBuilderError];
	
	NSLog(@"buildURL: %@ (%@)", builderURL, requestBuilderError);
	
	if (requestBuilderError != nil) {
		[self setError:requestBuilderError];
	} else {
		[self setFetchURL:builderURL];
	}
	
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
			SKObject *object = [[self entity] objectMergedWithDictionary:dataDictionary inSite:[self site]];
			[objects addObject:object];
		}
	} else if ([dataObject isKindOfClass:[NSDictionary class]]) {
		SKObject *object = [[self entity] objectMergedWithDictionary:dataObject inSite:[self site]];
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
