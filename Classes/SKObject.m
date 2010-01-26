//
//  SKObject.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@implementation SKObject

- (id) initWithSite:(SKSite *)aSite {
	if (self = [super init]) {
		site = aSite;
	}
	return self;
}

- (SKSite *) site {
	return [[site retain] autorelease];
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

@end
