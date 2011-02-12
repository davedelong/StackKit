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

#import "SKSiteStats.h"

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
	
	SKSiteStats *stats = nil;
    NSDictionary *responseDictionary = [responseString JSONValue];
    
	if ([responseDictionary isKindOfClass:[NSDictionary class]] && !error) {
        NSDictionary *dictionary = nil;
        NSArray *statsArray = [responseDictionary objectForKey:@"statistics"];
        
        if([statsArray isKindOfClass:[NSArray class]]) {   
            dictionary = [statsArray objectAtIndex:0];
        }
        
        if(dictionary) {
            stats = [SKSiteStats statsForSite:[self site] withResponseDictionary:dictionary];
        }
    }
    
    SKStatisticsHandler h = [self handler];
    dispatch_async(dispatch_get_main_queue(), ^{
        h(stats);
    });
}

- (void)dealloc {
    [handler release];
    [super dealloc];
}

@end
