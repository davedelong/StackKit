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
#import "SKSiteManager+Private.h"
#import "SKDefinitions.h"
#import "SKMacros.h"

// used internally
NSString * const SKUserAccountTypeAnonymous = @"anonymous";
NSString * const SKUserAccountTypeUnregistered = @"unregistered";
NSString * const SKUserAccountTypeRegistered = @"registered";
NSString * const SKUserAccountTypeModerator = @"moderator";

@implementation SKUser 

+ (id) userWithAssociationInformation:(NSDictionary *)information {
    NSString *siteName = [information objectForKey:@"site_name"];
    SKSite *site = [[SKSiteManager sharedManager] siteWithName:siteName];
    if (site == nil) { return nil; }
    
    return [SKUser objectMergedWithDictionary:information inSite:site];
}

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
				   @"answerCount", SKAPIAnswer_Count,
				   @"questionCount", SKAPIQuestion_Count,
                   @"websiteURL", SKAPIWebsite_URL,
                   nil];
    }
    return mapping;
}

- (SKFetchRequest *) mergeRequest {
    SKFetchRequest *r = [[SKFetchRequest alloc] init];
    [r setEntity:[SKUser class]];
    [r setPredicate:[NSPredicate predicateWithFormat:@"userID = %@", [self userID]]];
    
    return [r autorelease];
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

+ (NSString *)apiResponseUniqueIDKey {
    return SKAPIUser_ID;
}

+ (NSString *) apiResponseDataKey {
    return @"users";
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

SK_GETTER(NSString *, aboutMe);
SK_GETTER(NSNumber *, acceptRate);
SK_GETTER(NSNumber *, age);
SK_GETTER(NSString *, associationID);
SK_GETTER(NSDate *, creationDate);
SK_GETTER(NSString *, displayName);
SK_GETTER(NSNumber *, downVotes);
SK_GETTER(NSString *, emailHash);
SK_GETTER(NSDate *, lastAccessDate);
SK_GETTER(NSString *, location);
SK_GETTER(NSNumber *, reputation);
SK_GETTER(NSNumber *, upVotes);
SK_GETTER(NSNumber *, userID);
SK_GETTER(NSNumber *, userType);
SK_GETTER(NSNumber *, viewCount);
SK_GETTER(NSNumber *, answerCount);
SK_GETTER(NSNumber *, questionCount);
SK_GETTER(NSURL *, websiteURL);
SK_GETTER(NSSet *, awardedBadges);
SK_GETTER(NSSet *, directedComments);
SK_GETTER(NSSet *, posts);
SK_GETTER(NSSet *, favoritedQuestions);

- (NSSet *) questions {
    return [[self posts] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name = 'SKQuestion'"]];
}

- (NSSet *) answers {
    return [[self posts] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name = 'SKAnswer'"]];
}

- (NSSet *) comments {
    return [[self posts] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name = 'SKComment'"]];
}

@end
