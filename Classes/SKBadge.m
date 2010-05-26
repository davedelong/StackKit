//
//  SKBadge.m
//  StackKit
//
//  Created by Alex Rozanski on 26/01/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com
//

#import "StackKit_Internal.h"

NSString * SKBadgeID = @"badge_id";
NSString * SKBadgeRank = @"rank";
NSString * SKBadgeName = @"name";
NSString * SKBadgeDescription = @"description";
NSString * SKBadgeAwardCount = @"award_count";
NSString * SKBadgeTagBased = @"tag_based";
NSString * SKBadgeAwardedToUser = __SKUserID;

NSString * SKBadgeRankGoldKey = @"gold";
NSString * SKBadgeRankSilverKey = @"silver";
NSString * SKBadgeRankBronzeKey = @"bronze";

@implementation SKBadge

@synthesize name;
@synthesize description;
@synthesize ID;
@synthesize rank;
@synthesize numberAwarded;
@synthesize tagBased;

#pragma mark SKObject methods:

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		ID = [[dictionary objectForKey:SKBadgeID] retain];
		description = [[dictionary objectForKey:SKBadgeDescription] retain];
		name = [[dictionary objectForKey:SKBadgeName] retain];
		
		numberAwarded = [[dictionary objectForKey:SKBadgeAwardCount] integerValue];
		
		rank = SKBadgeRankBronze;
		if ([[dictionary objectForKey:SKBadgeRank] isEqual:SKBadgeRankGoldKey]) {
			rank = SKBadgeRankGold;
		} else if ([[dictionary objectForKey:SKBadgeRank] isEqual:SKBadgeRankSilverKey]) {
			rank = SKBadgeRankSilver;
		}
		
		tagBased = [[dictionary objectForKey:SKBadgeTagBased] boolValue];
	}
	return self;
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKBadgeMappings = nil;
	if (_kSKBadgeMappings == nil) {
		_kSKBadgeMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
							 @"name", SKBadgeName,
							 @"description", SKBadgeDescription,
							 @"ID", SKBadgeID,
							 @"rank", SKBadgeRank,
							 @"numberAwarded", SKBadgeAwardCount,
							 @"tagBased", SKBadgeTagBased,
							 @"userID", SKUserID,
							 nil];
	}
	return _kSKBadgeMappings;
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	/**
	 Possible badge endpoints:
	 
	 /badges (which is the same as /badges/name)
	 /users/{id}/badges
	 /badges/tags
	 /badges/{id}
	 
	 Therefore, the only supported predicates are:
	 
	 SKBadgeAwardedToUser = ##
	 SKBadgeID = ##
	 SKBadgeTagBased = 1
	 
	 **/
	
	
	NSPredicate * p = [request predicate];
	NSString * path = nil;
	
	if (p != nil) {
		
		NSArray * validKeyPaths = [NSArray arrayWithObjects:SKBadgeAwardedToUser, SKBadgeTagBased, SKBadgeID, nil];
		if ([p isComparisonPredicateWithLeftKeyPaths:validKeyPaths 
											operator:NSEqualToPredicateOperatorType 
								 rightExpressionType:NSConstantValueExpressionType] == NO) {
			return invalidPredicateErrorForFetchRequest(request, nil);
		}
		
		//if we get here, then the predicate is of the proper format
		NSNumber * badgesByTag = [p constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKBadgeTagBased]];
		id badgesForUser = [p constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKBadgeAwardedToUser]];
		id badgeID = [p constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKBadgeID]];
		
		if (badgesByTag != nil) {
			path = @"/badges/tags";
		} else if (badgesForUser != nil) {
			NSNumber * userID = nil;
			if ([badgesForUser isKindOfClass:[SKUser class]]) {
				userID = [badgesForUser userID];
			} else if ([badgesForUser isKindOfClass:[NSNumber class]]) {
				userID = badgesForUser;
			} else {
				userID = [NSNumber numberWithInt:[[badgesForUser description] intValue]];
			}
			path = [NSString stringWithFormat:@"/users/%@/badges", userID];
		} else if (badgeID != nil) {
			if ([badgeID isKindOfClass:[NSNumber class]] == NO) {
				badgeID = [NSNumber numberWithInt:[[badgeID description] intValue]];
			}
			path = [NSString stringWithFormat:@"/badges/%@", badgeID];
		}
	} else {
		//there is no predicate
		//we are requesting either /badges or /badges/name (which are identical)
		path = @"/badges";
	}
	
	if (path == nil) {
		//we somehow got a nil path.  not sure why...
		return invalidPredicateErrorForFetchRequest(request, nil);
	}
	
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:[[request site] apiKey] forKey:SKSiteAPIKey];	
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:path query:query];
	
	return apiCall;
}

#pragma mark SKBadge-specific methods

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self ID] isEqual:[object ID]]);
}

- (void)dealloc
{
	[name release];
	[description release];
	[ID release];
	
	[super dealloc];
}

@end
