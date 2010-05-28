//
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * const SKUserID = __SKUserID;
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

NSString * SKUserAccountTypeModerator = @"moderator";
NSString * SKUserAccountTypeRegistered = @"registered";

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
		if ([dictionary objectForKey:SKUserWebsiteURL] != nil) {
			websiteURL = [[NSURL alloc] initWithString:[dictionary objectForKey:SKUserWebsiteURL]];
		}
		location = [[dictionary objectForKey:SKUserLocation] retain];
		aboutMe = [[dictionary objectForKey:SKUserAboutMe] retain];
		
		creationDate = [[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserCreationDate] doubleValue]] retain];
		lastAccessDate = [[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserLastAccessDate] doubleValue]] retain];
		
		reputation = [[dictionary objectForKey:SKUserReputation] integerValue];
		age = [[dictionary objectForKey:SKUserAge] integerValue];
		views = [[dictionary objectForKey:SKUserViews] integerValue];
		upVotes = [[dictionary objectForKey:SKUserUpVotes] integerValue];
		downVotes = [[dictionary objectForKey:SKUserDownVotes] integerValue];
		acceptRate = [[dictionary objectForKey:SKUserAcceptRate] floatValue];
		
		userType = SKUserTypeRegistered;
		if ([[dictionary objectForKey:SKUserType] isEqual:SKUserAccountTypeModerator]) {
			userType = SKUserTypeModerator;
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

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	/**
	 endpoints returning user objects:
	 /users
	 /users/{id}
	 
	 This means that *only* predicate that's supported is:
	 SKUserID = ##
	 
	 **/
	
	NSPredicate * p = [request predicate];
	NSString * path = nil;
	
	if (p != nil) {
		
		NSArray * validLeftKeyPaths = [NSArray arrayWithObject:SKUserID];
		if ([p isComparisonPredicateWithLeftKeyPaths:validLeftKeyPaths 
											operator:NSEqualToPredicateOperatorType 
								 rightExpressionType:NSConstantValueExpressionType] == NO) {
			return invalidPredicateErrorForFetchRequest(request, nil);
		}
		
		//if we get here, we know the predicate is SKUserID = constantValue
		id user = [p constantValueForLeftKeyPath:SKUserID];
		NSNumber * userID = SKExtractUserID(user);
		path = [NSString stringWithFormat:@"/users/%@", userID];
	} else {
		//there is no predicate
		path = @"/users";
	}
	
	NSURL * baseURL = [[request site] apiURL];
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:[[request site] apiKey] forKey:SKSiteAPIKey];
	
	//TODO: sorting
	
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
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:baseURL relativePath:path query:query];
	
	return apiCall;
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self userID] isEqual:[object userID]]);
}

- (NSArray *) badges {
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, [self userID]]];
	
	NSArray * badges = [[self site] executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	return badges;
}

- (NSArray *) tags {
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKTag class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKUserID, [self userID]]];
	
	NSArray * tags = [[self site] executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	return tags;
}

@end
