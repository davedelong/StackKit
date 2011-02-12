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
@dynamic viewCount;
@dynamic websiteURL;

@dynamic awardedBadges;
@dynamic directedComments;
@dynamic posts;
@dynamic favoritedQuestions;

+ (NSDictionary *) APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"aboutMe", SKAPIAbout_Me,
                   @"acceptRate", SKAPIAccept_Rate,
                   @"age", SKAPIAge,
                   @"associationID", SKAPIAssociation_ID,
                   @"creationDate", SKAPICreation_Date,
                   @"displayName", SKAPIDisplay_Name,
                   @"downVotes", SKAPIDown_Vote_Count,
                   @"emailHash", SKAPIEmail_Hash,
                   @"lastAccessDate", SKAPILast_Access_Date,
                   @"location", SKAPILocation,
                   @"reputation", SKAPIReputation,
                   @"upVotes", SKAPIUp_Vote_Count,
                   @"userID", SKAPIUser_ID,
                   @"userType", SKAPIUser_Type,
                   @"viewCount", SKAPIView_Count,
                   @"websiteURL", SKAPIWebsite_URL,
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

+ (NSString*)entityName
{
    return @"SKUser";
}

+ (NSString *)apiResponseUniqueIDKey {
    return SKUserID;
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
