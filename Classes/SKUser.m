//
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@interface SKUser ()

- (void) loadFlair;
- (void) loadFavorites;

@end


@implementation SKUser

@synthesize userID;
@synthesize displayName, profileURL, reputation;
@synthesize favorites;

- (id) initWithSite:(SKSite *)aSite userID:(NSString *)anID {
	SKUser * cachedUser = [[aSite cachedUsers] objectForKey:anID];
	if (cachedUser != nil) {
		[self release];
		return [cachedUser retain];
	}
	
	if (self = [super initWithSite:aSite]) {
		userID = [anID copy];
		
		_flairLoaded = NO;
		favorites = [[NSMutableSet alloc] init];
	}
	
	[aSite cacheUser:self];
	
	return self;
}

- (void) dealloc {
	[userID release];
	[profileURL release];
	[displayName release];
	[favorites release];
	[super dealloc];
}

- (NSString *) displayName {
	if (_flairLoaded == NO) {
		[self loadFlair];
	}
	return displayName;
}

- (NSURL *) profileURL {
	if (_flairLoaded == NO) {
		[self loadFlair];
	}
	return profileURL;
}

- (NSUInteger) reputation {
	if (_flairLoaded == NO) {
		[self loadFlair];
	}
	return reputation;	
}

- (NSSet *) favorites {
	if (_favoritesLoaded == NO) {
		[self loadFavorites];
	}
	return favorites;
}

#pragma mark -
#pragma mark Private Methods

- (void) loadJSON:(NSDictionary *)jsonDictionary {
	if ([jsonDictionary objectForKey:@"profileUrl"] != nil) {
		profileURL = [[NSURL alloc] initWithString:[jsonDictionary objectForKey:@"profileUrl"]];
	}
	if ([jsonDictionary objectForKey:@"displayName"] != nil) {
		displayName = [[jsonDictionary objectForKey:@"displayName"] retain];
	}
	if ([jsonDictionary objectForKey:@"reputation"] != nil) {
		//we need a number formatter, because reputation comes back as a string
		NSNumberFormatter * f = [NSNumberFormatter basicFormatter];
		NSNumber * n = [f numberFromString:[jsonDictionary objectForKey:@"reputation"]];
		reputation = [n unsignedIntegerValue];
	}
}

- (void) loadFlair {
	NSString * flairPath = [NSString stringWithFormat:@"/users/flair/%@.json", [self userID]];
	NSURL * flairURL = [NSURL URLWithString:flairPath relativeToURL:[[self site] siteURL]];
	NSURLRequest * flairRequest = [NSURLRequest requestWithURL:flairURL];
	
	NSURLResponse * flairResponse = nil;
	NSError * flairError = nil;
	NSData * flairData = [NSURLConnection sendSynchronousRequest:flairRequest returningResponse:&flairResponse error:&flairError];
	if (flairError != nil) {
		NSLog(@"Error retrieving flair: %@", flairError);
		return;
	}
	NSString * jsonString = [[NSString alloc] initWithData:flairData encoding:NSUTF8StringEncoding];
	NSDictionary * jsonDictionary = [jsonString JSONValue];
	if (jsonDictionary == nil) {
		NSLog(@"Error parsing flair");
		return;
	}
	
	[self loadJSON:jsonDictionary];
	
	//don't set the flag until the end
	//that way if we error, we'll try to reload later
	_flairLoaded = YES;
}

- (void) loadFavorites {
	NSString * favPath = [NSString stringWithFormat:@"/api/userfavorites.json?userid=%@&page=0&pagesize=100", [self userID]];
	NSURL * favURL = [NSURL URLWithString:favPath relativeToURL:[[self site] siteURL]];
	NSURLRequest * favRequest = [NSURLRequest requestWithURL:favURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:[[self site] timeoutInterval]];
	NSLog(@"request: %@", favRequest);

	NSURLResponse * favResponse = nil;
	NSError * favError = nil;
	NSData * favData = [NSURLConnection sendSynchronousRequest:favRequest returningResponse:&favResponse error:&favError];
	if (favError != nil) {
		NSLog(@"Error retrieving favorites: %@", favError);
		return;
	}
	NSString * jsonString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
	NSArray * jsonArray = [jsonString JSONValue];
	if (jsonArray == nil) {
		NSLog(@"Error parsing favorites");
		return;
	}
	
	for (NSDictionary * jsonFavorite in jsonArray) {
		SKQuestion * favorite = [[SKQuestion alloc] initWithSite:[self site] json:jsonFavorite];
		[favorites addObject:favorite];
		[favorite release];
	}
	
	_favoritesLoaded = YES;
	
}

@end
