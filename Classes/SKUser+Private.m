//
//  SKUser+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKUser+Private.h"
#import "SKObject+Private.h"
#import "SKConstants_Internal.h"

NSString * const SKUserID = __SKUserID;
NSString * const SKUserReputation = @"reputation";
NSString * const SKUserCreationDate = @"creation_date";
NSString * const SKUserDisplayName = @"display_name";
NSString * const SKUserEmailHash = @"email_hash";
NSString * const SKUserAge = @"age";
NSString * const SKUserLastAccessDate = @"last_access_date";
NSString * const SKUserWebsiteURL = @"website_url";
NSString * const SKUserLocation = @"location";
NSString * const SKUserAboutMe = @"about_me";
NSString * const SKUserViews = @"view_count";
NSString * const SKUserUpVotes = @"up_vote_count";
NSString * const SKUserDownVotes = @"down_vote_count";
NSString * const SKUserType = @"user_type";
NSString * const SKUserAcceptRate = @"accept_rate";

NSString * const SKUserQuestionCount = @"question_count";
NSString * const SKUserAnswerCount = @"answer_count";

NSString * const SKUserBadges = @"user_badges";

//used internally
NSString * const SKUserAccountTypeAnonymous = @"anonymous";
NSString * const SKUserAccountTypeUnregistered = @"unregistered";
NSString * const SKUserAccountTypeRegistered = @"registered";
NSString * const SKUserAccountTypeModerator = @"moderator";

@implementation SKUser (Private)

@dynamic downVotes;
@dynamic lastAccessDate;
@dynamic userID;
@dynamic upVotes;
@dynamic age;
@dynamic userType;
@dynamic websiteURL;
@dynamic displayName;
@dynamic aboutMe;
@dynamic location;
@dynamic reputation;
@dynamic acceptRate;
@dynamic emailHash;
@dynamic creationDate;
@dynamic views;
@dynamic posts;
@dynamic badges;
@dynamic directedComments;

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {
	[self setUserID:[dictionary objectForKey:SKUserID]];
	[self setDisplayName:[dictionary objectForKey:SKUserDisplayName]];
	[self setEmailHash:[dictionary objectForKey:SKUserEmailHash]];
	
	if ([dictionary objectForKey:SKUserWebsiteURL] != nil) {
		[self setWebsiteURL:[NSURL URLWithString:[dictionary objectForKey:SKUserWebsiteURL]]];
	}
	
	[self setLocation:[dictionary objectForKey:SKUserLocation]];
	[self setAboutMe:[dictionary objectForKey:SKUserAboutMe]];
	
	[self setCreationDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserCreationDate] doubleValue]]];
	[self setLastAccessDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserLastAccessDate] doubleValue]]];
	
	[self setReputation:[dictionary objectForKey:SKUserReputation]];
	[self setAge:[dictionary objectForKey:SKUserAge]];
	[self setViews:[dictionary objectForKey:SKUserViews]];
	[self setUpVotes:[dictionary objectForKey:SKUserUpVotes]];
	[self setDownVotes:[dictionary objectForKey:SKUserDownVotes]];
	[self setAcceptRate:[dictionary objectForKey:SKUserAcceptRate]];
	
	NSString * type = [dictionary objectForKey:SKUserType];
	SKUserType_t uType = SKUserTypeRegistered;
	if ([type isEqual:SKUserAccountTypeModerator]) {
		uType = SKUserTypeModerator;
	} else if ([type isEqual:SKUserAccountTypeUnregistered]) {
		uType = SKUserTypeUnregistered;
	} else if ([type isEqual:SKUserAccountTypeAnonymous]) {
		uType = SKUserTypeAnonymous;
	}
	[self setUserType:[NSNumber numberWithInt:uType]];
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

+ (NSString *) dataKey {
	return @"users";
}

+ (NSString *) uniqueIDKey {
	return SKUserID;
}

@end
