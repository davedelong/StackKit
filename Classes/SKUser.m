//
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKUser.h"
#import "SKSite.h"
#import "SKSite+Private.h"
#import "JSON.h"

@implementation SKUser

@synthesize userID;
@synthesize displayName, profileURL, reputation;

- (id) initWithSite:(SKSite *)aSite userID:(NSString *)anID {
	SKUser * cachedUser = [[aSite cachedUsers] objectForKey:anID];
	if (cachedUser != nil) {
		[self release];
		return [cachedUser retain];
	}
	
	if (self = [super initWithSite:aSite]) {
		userID = [anID copy];
		//request info from [[self site] siteURL];
		
		NSString * flairPath = [NSString stringWithFormat:@"/users/flair/%@.json", anID];
		NSURL * flairURL = [NSURL URLWithString:flairPath relativeToURL:[[self site] siteURL]];
		NSURLRequest * flairRequest = [NSURLRequest requestWithURL:flairURL];
		
		NSURLResponse * flairResponse = nil;
		NSError * flairError = nil;
		NSData * flairData = [NSURLConnection sendSynchronousRequest:flairRequest returningResponse:&flairResponse error:&flairError];
		if (flairError != nil) {
			NSLog(@"Error retrieving flair: %@", flairError);
			[self release];
			return nil;
		}
		NSString * jsonString = [[NSString alloc] initWithData:flairData encoding:NSUTF8StringEncoding];
		NSDictionary * jsonDictionary = [jsonString JSONValue];
		if (jsonDictionary == nil) {
			NSLog(@"Error parsing flair");
			[self release];
			return nil;
		}
		
		profileURL = [[NSURL alloc] initWithString:[jsonDictionary objectForKey:@"profileUrl"]];
		displayName = [[jsonDictionary objectForKey:@"displayName"] retain];
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * n = [f numberFromString:[jsonDictionary objectForKey:@"reputation"]];
		NSLog(@"Parsed number: %@", n);
		reputation = [n unsignedIntegerValue];
		[f release];
	}
	
	[aSite cacheUser:self];
	
	return self;
}

- (void) dealloc {
	[userID release];
	[super dealloc];
}

@end
