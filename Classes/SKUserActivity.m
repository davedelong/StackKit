//
//  SKUserActivity.m
//  StackKit
//
//  Created by Dave DeLong on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * SKUserActivityType = @"timeline_type";
NSString * SKUserActivityPostID = @"post_id";
NSString * SKUserActivityPostType = @"post_type";
NSString * SKUserActivityCommentID = @"comment_id";
NSString * SKUserActivityAction = @"action";
NSString * SKUserActivityCreationDate = @"creation_date";
NSString * SKUserActivityDescription = @"description";
NSString * SKUserActivityDetail = @"detail";

@implementation SKUserActivity

@synthesize type;
@synthesize postID;
@synthesize postType;
@synthesize commentID;
@synthesize action;
@synthesize creationDate;
@synthesize activityDescription;
@synthesize activityDetail;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKUserActivityMappings = nil;
	if (_kSKUserActivityMappings == nil) {
		_kSKUserActivityMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
									@"badgeName", SKBadgeName,
									@"badgeDescription", SKBadgeDescription,
									@"badgeID", SKBadgeID,
									@"badgeColor", SKBadgeColor,
									@"numberOfBadgesAwarded", SKBadgeAwardCount,
									@"tagBased", SKBadgeTagBased,
									@"userID", SKUserID,
									nil];
	}
	return _kSKUserActivityMappings;
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request error:(NSError **)error {
	/**
	 Possible activity endpoints:
	 
	 /users/{id}/timeline
	 
	 **/
	
	NSMutableString * relativeString = [NSMutableString string];
	
	NSPredicate * p = [request predicate];
	id activityForUser = [p constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKUserID]];
	
	if (p != nil && activityForUser != nil) {
		//retrieve badges for a specific user
		
		NSNumber * userID = nil;
		if ([activityForUser isKindOfClass:[SKUser class]]) {
			userID = [activityForUser userID];
		} else if ([activityForUser isKindOfClass:[NSNumber class]]) {
			userID = activityForUser;
		} else {
			userID = [NSNumber numberWithInt:[[activityForUser description] intValue]];
		}
		
		[relativeString appendFormat:@"/users/%@/timeline", userID];
	} else {
		//we can't operate without a predicate or a userID
		if (error != nil) {
			*error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil];
		}
		return nil;
	}
	
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:[[request site] apiKey] forKey:SKSiteAPIKey];
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:relativeString query:query];
	
	return apiCall;
}

+ (NSPredicate *) updatedPredicateForFetchRequest:(SKFetchRequest *)request {
	return [[request predicate] predicateByRemovingSubPredicateWithLeftExpression:[NSExpression expressionForKeyPath:SKUserID]];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		NSLog(@"%@", dictionary);
	}
	return self;
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([self type] == [(SKUserActivity *)object type] &&
			[self action] == [(SKUserActivity *)object action] &&
			[[self creationDate] isEqualToDate:[object creationDate]]			
			);
}

@end
