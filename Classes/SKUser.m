//
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * SKUserID = @"UserId";
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

//used internally
NSUInteger SKUserDefaultPageSize = 35;
NSString * SKUserPage = @"page";
NSString * SKUserPageSize = @"pagesize";

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
	NSArray * sortDescriptors = [request sortDescriptors];
	
	if (sortDescriptors != nil) {
		//we have to look for sortDescriptors for SKUserReputation, SKUserCreationDate, and SKUserDisplayName
		//however, we can only use *one* of those.  we'll use the first one that we find
		NSArray * sortableStuff = [NSArray arrayWithObjects:SKUserReputation, SKUserCreationDate, SKUserDisplayName, nil];
		for (NSSortDescriptor * sort in sortDescriptors) {
			if ([sortableStuff containsObject:[sort key]]) {
				if ([[sort key] isEqual:SKUserReputation]) {
					[relativeString appendString:@"/reputation"];
				} else if ([[sort key] isEqual:SKUserDisplayName]) {
					[relativeString appendString:@"/name"];
				} else if ([[sort key] isEqual:SKUserCreationDate] && [sort ascending] == YES) {
					//oldest first
					[relativeString appendString:@"/oldest"];
				} else if ([[sort key] isEqual:SKUserCreationDate] && [sort ascending] == NO) {
					//newest first
					[relativeString appendString:@"/newest"];
				}
				
				break;
			}
		}
	}
	
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:apiKey forKey:SKSiteAPIKey];
	if ([request fetchOffset] != 0 || [request fetchLimit] != 0) {
		/** three use cases:
		 fetchOffset + fetchLimit =>
		 pagesize = fetchlimit
		 page = floor(offset / pagesize)
		 
		 fetchOffset =>
		 pagesize = defaultPageSize [35]
		 page = floor(offset / pagesize)
		 
		 fetchLimit =>
		 pagesize = fetchlimit
		 page = 1
		 
		 NOTE: this might not always return exact matches, but it should be ok as long as the fetchLimit doesn't change too wildly
		 **/
		
		NSUInteger pagesize = ([request fetchLimit] > 0 ? [request fetchLimit] : SKUserDefaultPageSize);
		NSUInteger page = ([request fetchOffset] > 0 ? floor([request fetchOffset]/pagesize) : 1);
		
		[query setObject:[NSNumber numberWithUnsignedInteger:pagesize] forKey:SKUserPageSize];
		[query setObject:[NSNumber numberWithUnsignedInteger:page] forKey:SKUserPage];
	}
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:baseURL relativePath:relativeString query:query];
	
	return apiCall;
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"userID", SKUserID,
			@"displayName", SKUserDisplayName,
			@"emailHash", SKUserEmailHash,
			@"websiteURL", SKUserWebsiteURL,
			@"location", SKUserLocation,
			@"aboutMe", SKUserAboutMe,
			@"creationDate", SKUserCreationDate,
			@"lastAccessDate", SKUserLastAccessDate,
			@"reputation", SKUserReputation,
			@"age", SKUserAge,
			@"upVotes", SKUserUpVotes,
			@"downVotes", SKUserDownVotes,
			@"moderator", SKUserIsModerator,
			@"acceptRate", SKUserAcceptRate,
			nil];
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

#pragma mark KVC Compliance

- (id) valueForUndefinedKey:(NSString *)key {
	NSString * newKey = [[[self class] APIAttributeToPropertyMapping] objectForKey:key];
	if (newKey != nil) {
		return [self valueForKey:newKey];
	}
	return [super valueForUndefinedKey:key];
}

@end
