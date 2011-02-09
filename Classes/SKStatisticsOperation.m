//
//  SKStatisticsOperation.m
//  StackKit
//
//  Created by Dave DeLong on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKStatisticsOperation.h"
#import "NSDictionary+SKAdditions.h"
#import "JSON.h"

#import <dispatch/dispatch.h>

@implementation SKStatisticsOperation
@synthesize handler;

- (id) initWithSite:(SKSite *)baseSite completionHandler:(SKStatisticsHandler)aHandler {
    self = [super initWithSite:baseSite];
    if (self) {
        [self setHandler:aHandler];
    }
    return self;
}

- (void) main {
    
	NSDictionary * queryDictionary = [NSDictionary dictionaryWithObject:[[self site] apiKey] forKey:SKSiteAPIKey];
	NSString * statsPath = [NSString stringWithFormat:@"stats?%@", [queryDictionary queryString]];
	
	NSString * statsCall = [[[[self site] apiURL] absoluteString] stringByAppendingPathComponent:statsPath];
	
	NSURL * statsURL = [NSURL URLWithString:statsCall];
	
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[statsURL absoluteURL]];
	NSURLResponse * response = nil;
	
    NSError *error = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSDictionary * statistics = [responseString JSONValue];
    
	if ([statistics isKindOfClass:[NSDictionary class]] == NO || error != nil) {
        statistics = nil;
    }
    
    SKStatisticsHandler h = [self handler];
    dispatch_async(dispatch_get_main_queue(), ^{
        h(statistics);
    });
}

- (void)dealloc {
    [handler release];
    [super dealloc];
}

@end
