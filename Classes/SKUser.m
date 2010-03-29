//
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * SKUserID = @"Id";
NSString * SKUserReputation = @"Reputation";
NSString * SKUserCreationDate = @"CreationDate";
NSString * SKUserDisplayName = @"DisplayName";
NSString * SKUserEmailHash = @"EmailHash";
NSString * SKUserAge = @"Age";
NSString * SKUserLastAccessDate = @"LastAccessDate";
NSString * SKUserWebsiteURL = @"WebsiteUrl";
NSString * SKUserLocation = @"Location";
NSString * SKUserAboutMe = @"AboutMe";
NSString * SKUserViews = @"Views";
NSString * SKUserUpVotes = @"UpVotes";
NSString * SKUserDownVotes = @"DownVotes";
NSString * SKUserIsModerator = @"IsModerator";
NSString * SKUserAcceptRate = @"AcceptRate";


@interface SKUser ()

- (id) initWithSite:(SKSite *)aSite userID:(NSString *)anID;

- (void) loadFlair;
- (void) loadFavorites;
- (void) loadBadges;

@end


@implementation SKUser

@synthesize userID;
@synthesize displayName, profileURL, reputation;
@synthesize favorites;
@synthesize badges;

#pragma mark Official SO api:

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	NSURL * baseURL = [[request site] apiURL];
	NSString * apiKey = [[request site] apiKey];
	
	NSMutableString * relativeString = [NSMutableString stringWithString:@"/users"];
	NSPredicate * predicate = [request predicate];
	if (predicate != nil) {
		//look for a "Id = [NSNumber]" predicate
		id userID = [predicate constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKUserID]];
		if (userID != nil) {
			[relativeString appendFormat:@"/%@", userID];
		}
	}
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:apiKey forKey:SKSiteAPIKey];
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:baseURL relativePath:relativeString query:query];
	
	return apiCall;
}

#pragma mark -
#pragma mark Init/Dealloc

//Convenience initializer
+ (id)userWithSite:(SKSite*)aSite userID:(NSString*)anID
{
	//Check if the user has already been cached
	id cachedUser = [[aSite cachedUsers] objectForKey:anID];
	if (cachedUser != nil) {
		return cachedUser;
	}
	
	//If not create a new user
	id newUser = [[[self class] alloc] initWithSite:aSite userID:anID];
	[aSite cacheUser:newUser];
	[newUser release];
	
	return newUser;
}

//Private initializer
- (id) initWithSite:(SKSite *)aSite userID:(NSString *)anID {	
	if (self = [super initWithSite:aSite]) {
		userID = [anID copy];
		
		_flairLoaded = NO;
		favorites = [[NSMutableSet alloc] init];
		badges = [[NSMutableSet alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[userID release];
	[profileURL release];
	[displayName release];
	[favorites release];
	[badges release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Custom Accessors

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

- (NSSet*)badges {
	if(_badgesLoaded == NO) {
		[self loadBadges];
	}
	
	return badges;
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
	NSURL * flairURL = [NSURL URLWithString:flairPath relativeToURL:[[self site] apiURL]];
	
	NSDictionary * flair = [self jsonObjectAtURL:flairURL];
	if (flair == nil) {
		NSLog(@"Error parsing flair");
		return;
	}
	
	[self loadJSON:flair];
	
	//don't set the flag until the end
	//that way if we error, we'll try to reload later
	_flairLoaded = YES;
}

- (void) loadFavorites {
	NSString * favPath = [NSString stringWithFormat:@"/api/userfavorites.json?userid=%@&page=0&pagesize=100", [self userID]];
	NSURL * favURL = [NSURL URLWithString:favPath relativeToURL:[[self site] apiURL]];
	
	NSArray * jsonArray = [self jsonObjectAtURL:favURL];
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

- (void) loadBadges
{
	//Skeleton method as no API available (yet)
	
	_badgesLoaded = YES;
}

@end
