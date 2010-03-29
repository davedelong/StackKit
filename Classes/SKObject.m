//
//  SKObject.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKObject
@synthesize site;

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super init]) {
		site = aSite;
	}
	return self;
}

- (void) loadJSON:(NSDictionary *)jsonDictionary {
	return;
}

- (id) jsonObjectAtURL:(NSURL *)aURL {
	NSURLRequest * req = [NSURLRequest requestWithURL:aURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[[self site] timeoutInterval]];
	
	NSURLResponse * resp = nil;
	NSError * error = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
	if (error != nil) {
		NSLog(@"Error loading URL: %@", error);
		return nil;
	}
	
	NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	id jsonValue = [jsonString JSONValue];
	[jsonString release];
	
	return jsonValue;
}

+ (NSURL *) constructAPICallForBaseURL:(NSURL *)base relativePath:(NSString *)path query:(NSDictionary *)query {
	NSString * queryString = [query queryString];
	if (queryString != nil) {
		path = [NSString stringWithFormat:@"%@?%@", path, queryString];
	}
	NSURL * relativeURL = [NSURL URLWithString:path relativeToURL:base];
	
	return [relativeURL absoluteURL];
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	if (error != nil) {
		*error = [NSError errorWithDomain:@"stackkit" code:0 userInfo:nil];
	}
	
	NSAssert(NO, ([NSString stringWithFormat:@"-[%@ %@] must be overridden", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]));
	return nil;
}

@end
