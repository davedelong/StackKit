//
//  SKBadge.m
//  StackKit
//
//  Created by Alex Rozanski on 26/01/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com
//

#import "StackKit_Internal.h"

NSString * SKBadgeID = @"badge_id";
NSString * SKBadgeColor = @"rank";
NSString * SKBadgeName = @"name";
NSString * SKBadgeDescription = @"description";
NSString * SKBadgeAwardCount = @"award_count";
NSString * SKBadgeTagBased = @"tag_based";

NSString * SKBadgeRankGold = @"gold";
NSString * SKBadgeRankSilver = @"silver";
NSString * SKBadgeRankBronze = @"bronze";

@implementation SKBadge

@synthesize badgeName;
@synthesize badgeDescription;
@synthesize badgeID;
@synthesize badgeColor;
@synthesize numberOfBadgesAwarded;
@synthesize tagBased;

#pragma mark SKObject methods:

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		badgeID = [[dictionary objectForKey:SKBadgeID] retain];
		badgeDescription = [[dictionary objectForKey:SKBadgeDescription] retain];
		badgeName = [[dictionary objectForKey:SKBadgeName] retain];
		
		numberOfBadgesAwarded = [[dictionary objectForKey:SKBadgeAwardCount] integerValue];
		
		badgeColor = SKBadgeColorBronze;
		if ([[dictionary objectForKey:SKBadgeColor] isEqual:SKBadgeRankGold]) {
			badgeColor = SKBadgeColorGold;
		} else if ([[dictionary objectForKey:SKBadgeColor] isEqual:SKBadgeRankSilver]) {
			badgeColor = SKBadgeColorSilver;
		}
		
		tagBased = [[dictionary objectForKey:SKBadgeTagBased] boolValue];
	}
	return self;
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKBadgeMappings = nil;
	if (_kSKBadgeMappings == nil) {
		_kSKBadgeMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
							 @"badgeName", SKBadgeName,
							 @"badgeDescription", SKBadgeDescription,
							 @"badgeID", SKBadgeID,
							 @"badgeColor", SKBadgeColor,
							 @"numberOfBadgesAwarded", SKBadgeAwardCount,
							 @"tagBased", SKBadgeTagBased,
							 @"userID", SKUserID,
							 nil];
	}
	return _kSKBadgeMappings;
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	/**
	 Possible badge endpoints:
	 
	 /users/{id}/badges
	 /badges/tags
	 /badges/name
	 
	 **/
	
	NSMutableString * relativeString = [NSMutableString string];
	
	NSPredicate * p = [request predicate];
	id badgesForUser = [p constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKUserID]];
	NSNumber * badgesByTag = [p constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKBadgeTagBased]];
	
	if (p != nil && badgesForUser != nil) {
		//retrieve badges for a specific user
		
		NSNumber * userID = nil;
		if ([badgesForUser isKindOfClass:[SKUser class]]) {
			userID = [badgesForUser userID];
		} else if ([badgesForUser isKindOfClass:[NSNumber class]]) {
			userID = badgesForUser;
		} else {
			userID = [NSNumber numberWithInt:[[badgesForUser description] intValue]];
		}
		
		[relativeString appendFormat:@"/users/%@/badges", userID];
	} else if (p != nil && [badgesByTag boolValue] == YES) {
		//retrieve tag badges
		[relativeString appendString:@"/badges/tags"];
	} else {
		//default to retrieving badges by name
		[relativeString appendString:@"/badges/name"];
	}
	
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:[[request site] apiKey] forKey:SKSiteAPIKey];
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:relativeString query:query];
	
	return apiCall;
}

+ (NSPredicate *) updatedPredicateForFetchRequest:(SKFetchRequest *)request {
	return [[request predicate] predicateByRemovingSubPredicateWithLeftExpression:[NSExpression expressionForKeyPath:SKUserID]];
}

#pragma mark SKBadge-specific methods

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self badgeID] isEqual:[object badgeID]]);
}

- (void)dealloc
{
	[badgeName release];
	[badgeDescription release];
	[badgeID release];
	
	[super dealloc];
}

@end
