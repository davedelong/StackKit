//
//  SKFetchOperation.m
//  StackKit
//
//  Created by Dave DeLong on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKFetchOperation.h"
#import "SKRequestBuilder.h"
#import "SKFetchRequest.h"
#import "SKFetchRequest+Private.h"
#import "SKObject+Private.h"
#import "SKSite+Private.h"
#import "SKConstants.h"
#import "JSON.h"

NSString * SKFetchTotalKey = @"total";

NSString * SKErrorResponseKey = @"error";
NSString * SKErrorCodeKey = @"code";
NSString * SKErrorMessageKey = @"message";

@implementation SKFetchOperation
@synthesize priorHandler, afterHandler, handler, error;

- (id) initWithSite:(SKSite *)baseSite fetchRequest:(SKFetchRequest *)aRequest {
    self = [super initWithSite:baseSite];
    if (self) {
        request = [aRequest retain];
        [request setSite:baseSite];
    }
    return self;
}

- (void) dealloc {
    [request release];
    [handler release];
    [priorHandler release];
    [afterHandler release];
    [error release];
    [super dealloc];
}

- (NSArray *) requestObjectsFromURL:(NSURL *)fetchURL {
	
	//signal that the request is about to begin
    if (priorHandler != nil) {
        SKActionBlock prior = [self priorHandler];
        dispatch_async(dispatch_get_main_queue(), ^{
            prior();
        });
    }
	
	//execute the GET request
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:fetchURL];
	NSURLResponse * response = nil;
	NSError * connectionError = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&connectionError];
	
	//signal that the request has ended
    if (afterHandler != nil) {
        SKActionBlock after = [self afterHandler];
        dispatch_async(dispatch_get_main_queue(), ^{
            after(); 
        });
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
	
    [request setFetchTotal:[[responseObjects objectForKey:SKFetchTotalKey] unsignedIntegerValue]];
	
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
    Class entity = [request entity];
	NSString * dataKey = [entity apiResponseDataKey];
	id dataObject = [responseObjects objectForKey:dataKey];
	
	NSMutableArray * objects = [[NSMutableArray alloc] init];	
	
	//parse the response into objects
    [[[self site] managedObjectContext] lock];
	if ([dataObject isKindOfClass:[NSArray class]]) {
		for (NSDictionary * dataDictionary in dataObject) {
			SKObject *object = [entity objectMergedWithDictionary:dataDictionary inSite:[self site]];
			[objects addObject:object];
		}
	} else if ([dataObject isKindOfClass:[NSDictionary class]]) {
		SKObject *object = [entity objectMergedWithDictionary:dataObject inSite:[self site]];
		[objects addObject:object];
	}
    [[[self site] managedObjectContext] unlock];
	
	return [objects autorelease];
}

- (void) main {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSArray * objects = nil;
	
	NSString * apiKey = [[self site] apiKey];
	if (apiKey == nil) {
        [self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidApplicationPublicKey userInfo:[NSDictionary dictionaryWithObject:@"API key is nil" forKey:NSLocalizedDescriptionKey]]];
		goto cleanup;
	}
	
	//construct our fetch url
	NSError * requestBuilderError = nil;
	NSURL * builderURL = [SKRequestBuilder URLForFetchRequest:request error:&requestBuilderError];
	
	NSLog(@"buildURL: %@ (%@)", builderURL, requestBuilderError);
	
	if (requestBuilderError != nil) {
		[self setError:requestBuilderError];
        goto cleanup;
	}
    
    if (builderURL == nil) {
        [self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeUnknownError userInfo:[NSDictionary dictionaryWithObject:@"URL building return nil" forKey:NSLocalizedDescriptionKey]]];
        goto cleanup;
    }
	
	objects = [self requestObjectsFromURL:builderURL];
	
cleanup:
    ;
    SKFetchRequestHandler h = [self handler];
    dispatch_async(dispatch_get_main_queue(), ^{
        h(objects);
    });
    
	[pool drain];
}

@end

