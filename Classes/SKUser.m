//
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * SKUserID = @"user_id";
NSString * SKUserReputation = @"reputation";
NSString * SKUserCreationDate = @"creation_date";
NSString * SKUserDisplayName = @"display_name";
NSString * SKUserEmailHash = @"email_hash";
NSString * SKUserAge = @"age";
NSString * SKUserLastAccessDate = @"last_access_date";
NSString * SKUserWebsiteURL = @"website_url";
NSString * SKUserLocation = @"location";
NSString * SKUserAboutMe = @"about_me";
NSString * SKUserViews = @"view_count";
NSString * SKUserUpVotes = @"up_vote_count";
NSString * SKUserDownVotes = @"down_vote_count";
NSString * SKUserType = @"user_type";
NSString * SKUserAcceptRate = @"accept_rate";

NSString * SKUserQuestionCount = @"question_count";
NSString * SKUserAnswerCount = @"answer_count";

//used internally
NSUInteger SKUserDefaultPageSize = 35;

NSString * SKUserTypeModerator = @"moderator";
NSString * SKUserTypeRegistered = @"registered";

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
@synthesize userType;
@synthesize acceptRate;

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
		acceptRate = [[dictionary objectForKey:SKUserAcceptRate] floatValue];
		
		userType = SKUserAccountTypeRegistered;
		if ([[dictionary objectForKey:SKUserType] isEqual:SKUserTypeModerator]) {
			userType = SKUserAccountTypeModerator;
		}
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

#pragma mark -
#pragma mark Fetch Requests

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKUserMappings = nil;
	if (_kSKUserMappings == nil) {
		_kSKUserMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
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
							@"userType", SKUserType,
							@"acceptRate", SKUserAcceptRate,
							nil];
	}
	return _kSKUserMappings;
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	/**
	 endpoints returning user objects:
	 /users/{id}
	 /users/reputation
	 /users/newest
	 /users/oldest
	 /users/name
	 
	 while there are other endpoints that have these same (or similar) prefixes,
	 only endpoints that return SKUser objects are constructed here
	 
	 **/
	NSURL * baseURL = [[request site] apiURL];
	NSString * apiKey = [[request site] apiKey];
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:apiKey forKey:SKSiteAPIKey];
	
	NSMutableString * relativeString = [NSMutableString stringWithString:@"/users"];
	NSPredicate * predicate = [request predicate];
	NSArray * sortDescriptors = [request sortDescriptors];
	
	if (predicate != nil) {
		//look for a "UserId = [NSNumber]" predicate
		id userID = [predicate constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKUserID]];
		id displayNameFilter = [predicate constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKUserDisplayName]];
		if (userID != nil && [userID isKindOfClass:[NSNumber class]]) {
			[relativeString appendFormat:@"/%@", userID];
		} else if (displayNameFilter != nil && [displayNameFilter isKindOfClass:[NSString class]]) {
			[query setObject:displayNameFilter forKey:@"filter"];
		}
	} else if (sortDescriptors != nil) {
		//we have to use an elseif here because /users/{id}/reputation is not a valid endpoint
		//so we'll prioritize looking for a specific user over looking for users sorted by {sortDescriptor}
		
		//we have to look for sortDescriptors for SKUserReputation, SKUserCreationDate, and SKUserDisplayName
		//however, we can only use *one* of those.  we'll use the first one that we find
		//we also have to translate them, in case they're using @"reputation" instead of SKUserReputation
		for (NSSortDescriptor * sort in sortDescriptors) {
			NSString * key = [[self class] propertyKeyFromAPIAttributeKey:[sort key]];
			if ([key isEqual:[[self class] propertyKeyFromAPIAttributeKey:SKUserReputation]]) {
				[relativeString appendString:@"/reputation"];
				break;
			} else if ([key isEqual:[[self class] propertyKeyFromAPIAttributeKey:SKUserDisplayName]]) {
				[relativeString appendString:@"/name"];
				break;
			} else if ([key isEqual:[[self class] propertyKeyFromAPIAttributeKey:SKUserCreationDate]] && [sort ascending] == YES) {
				//oldest first
				[relativeString appendString:@"/oldest"];
				break;
			} else if ([key isEqual:[[self class] propertyKeyFromAPIAttributeKey:SKUserCreationDate]] && [sort ascending] == NO) {
				//newest first
				[relativeString appendString:@"/newest"];
				break;
			}
		}
	}
	
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
		
		[query setObject:[NSNumber numberWithUnsignedInteger:pagesize] forKey:SKPageSizeKey];
		[query setObject:[NSNumber numberWithUnsignedInteger:page] forKey:SKPageKey];
	}
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:baseURL relativePath:relativeString query:query];
	
	return apiCall;
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self userID] isEqual:[object userID]]);
}

@end
