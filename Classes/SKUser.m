// 
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKUser.h"
#import "SKObject+Private.h"
#import "SKConstants_Internal.h"
#import "SKDefinitions.h"

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
NSString * const SKUserAssociationID = @"association_id";

NSString * const SKUserQuestionCount = @"question_count";
NSString * const SKUserAnswerCount = @"answer_count";

NSString * const SKUserBadges = @"user_badges";

// used internally
NSString * const SKUserAccountTypeAnonymous = @"anonymous";
NSString * const SKUserAccountTypeUnregistered = @"unregistered";
NSString * const SKUserAccountTypeRegistered = @"registered";
NSString * const SKUserAccountTypeModerator = @"moderator";

@implementation SKUser 

@dynamic aboutMe;
@dynamic acceptRate;
@dynamic age;
@dynamic associationID;
@dynamic creationDate;
@dynamic displayName;
@dynamic downVotes;
@dynamic emailHash;
@dynamic lastAccessDate;
@dynamic location;
@dynamic reputation;
@dynamic upVotes;
@dynamic userID;
@dynamic userType;
@dynamic views;
@dynamic websiteURL;

@dynamic awardedBadges;
@dynamic directedComments;
@dynamic posts;

+ (NSDictionary *) APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"aboutMe", SKUserAboutMe,
                   @"acceptRate", SKUserAcceptRate,
                   @"age", SKUserAge,
                   @"associationID", SKUserAssociationID,
                   @"creationDate", SKUserCreationDate,
                   @"displayName", SKUserDisplayName,
                   @"downVotes", SKUserDownVotes,
                   @"emailHash", SKUserEmailHash,
                   @"lastAccessDate", SKUserLastAccessDate,
                   @"location", SKUserLocation,
                   @"reputation", SKUserReputation,
                   @"upVotes", SKUserUpVotes,
                   @"userID", SKUserID,
                   @"userType", SKUserType,
                   @"views", SKUserViews,
                   @"websiteURL", SKUserWebsiteURL,
                   nil];
    }
    return mapping;
}

- (id) transformValueToMerge:(id)value forProperty:(NSString *)property {
    if ([property isEqualToString:@"userType"]) {
        
		SKUserType_t type = SKUserTypeRegistered;
		if ([value isEqual:SKUserAccountTypeModerator]) {
			type = SKUserTypeModerator;
		} else if ([value isEqual:SKUserAccountTypeUnregistered]) {
			type = SKUserTypeUnregistered;
		} else if ([value isEqual:SKUserAccountTypeAnonymous]) {
			type = SKUserTypeAnonymous;
		}
        return [NSNumber numberWithInt:type];
    }
    
    // super will convert dates and URLs for us
    return [super transformValueToMerge:value forProperty:property];
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    // override for the sake of completeness
    return [super transformValueToMerge:value forRelationship:relationship];
}

- (NSURL *) gravatarIconURL {
	return [self gravatarIconURLForSize:CGSizeMake(80, 80)];
}

- (NSURL *) gravatarIconURLForSize:(CGSize)size {
	if (size.width != size.height) { return nil; }
	int dimension = size.width;
	if (dimension <= 0) { dimension = 1; }
	if (dimension > 512) { dimension = 512; }
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=%d", [self emailHash], dimension]];
}

@end
