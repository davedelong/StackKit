//
//  SKUser.m
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

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

NSString * const SKUserBadges = @"user_badges";

//used internally
NSUInteger SKUserDefaultPageSize = 35;

NSString * SKUserAccountTypeAnonymous = @"anonymous";
NSString * SKUserAccountTypeUnregistered = @"unregistered";
NSString * SKUserAccountTypeRegistered = @"registered";
NSString * SKUserAccountTypeModerator = @"moderator";

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
		
		reputation = [[dictionary objectForKey:SKUserReputation] retain];
		age = [[dictionary objectForKey:SKUserAge] retain];
		views = [[dictionary objectForKey:SKUserViews] retain];
		upVotes = [[dictionary objectForKey:SKUserUpVotes] retain];
		downVotes = [[dictionary objectForKey:SKUserDownVotes] retain];
		acceptRate = [[dictionary objectForKey:SKUserAcceptRate] retain];
		
		NSString * type = [dictionary objectForKey:SKUserType];
		userType = SKUserTypeRegistered;
		if ([type isEqual:SKUserAccountTypeModerator]) {
			userType = SKUserTypeModerator;
		} else if ([type isEqual:SKUserAccountTypeUnregistered]) {
			userType = SKUserTypeUnregistered;
		} else if ([type isEqual:SKUserAccountTypeAnonymous]) {
			userType = SKUserTypeAnonymous;
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
	[reputation release];
	[age release];
	[views release];
	[upVotes release];
	[downVotes release];
	[acceptRate release];
	
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

+ (NSArray *) endpoints {
	return [NSArray arrayWithObjects:
			[SKAllUsersEndpoint class],
			[SKSpecificUserEndpoint class],
			nil];
}

+ (NSString *) dataKey {
	return @"users";
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self userID] isEqual:[object userID]]);
}

- (NSArray *) badges {
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKBadge class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKBadgesAwardedToUser, [self userID]]];
	
	NSArray * badges = [[self site] executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	return badges;
}

- (NSArray *) tags {
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKTag class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", SKTagsParticipatedInByUser, [self userID]]];
	
	NSArray * tags = [[self site] executeSynchronousFetchRequest:r error:nil];
	[r release];
	
	return tags;
}

@end
