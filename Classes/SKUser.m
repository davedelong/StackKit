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

@implementation SKUser

@synthesize userID;
@synthesize reputation;
@synthesize creationDate;
@synthesize displayName;
@synthesize emailHash;
@synthesize age;
@synthesize lastAccessDate;
@synthesize websiteURL;
@synthesize location;
@synthesize aboutMe;
@synthesize views;
@synthesize upVotes;
@synthesize downVotes;
@synthesize moderator;
@synthesize acceptRate;

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

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		userID = [[dictionary objectForKey:SKUserID] retain];
		displayName = [[dictionary objectForKey:SKUserDisplayName] retain];
		emailHash = [[dictionary objectForKey:SKUserEmailHash] retain];
		websiteURL = [[NSURL alloc] initWithString:[dictionary objectForKey:SKUserWebsiteURL]];
		location = [[dictionary objectForKey:SKUserLocation] retain];
		aboutMe = [[dictionary objectForKey:SKUserAboutMe] retain];
		
		creationDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserCreationDate] doubleValue]];
		lastAccessDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserLastAccessDate] doubleValue]];
		
		reputation = [[dictionary objectForKey:SKUserReputation] integerValue];
		age = [[dictionary objectForKey:SKUserAge] integerValue];
		views = [[dictionary objectForKey:SKUserViews] integerValue];
		upVotes = [[dictionary objectForKey:SKUserUpVotes] integerValue];
		downVotes = [[dictionary objectForKey:SKUserDownVotes] integerValue];
		moderator = [[dictionary objectForKey:SKUserIsModerator] boolValue];
		acceptRate = [[dictionary objectForKey:SKUserAcceptRate] floatValue];
	}
	return self;
}

- (void) dealloc {
	[userID release];
	[creationDate release];
	[displayName release];
	[emailHash release];
	[lastAccessDate release];
	[websiteURL release];
	[location release];
	[aboutMe release];
	
	[super dealloc];
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self userID] isEqual:[object userID]]);
}

@end
