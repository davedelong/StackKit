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

//internal

//actions
NSString * SKUserActivityActionComment = @"comment";
NSString * SKUserActivityActionRevised = @"revised";
NSString * SKUserActivityActionAwarded = @"awarded";
NSString * SKUserActivityActionAnswered = @"answered";

//timeline types
NSString * SKUserActivityTimelineTypeComment = @"comment";
NSString * SKUserActivityTimelineTypeRevision = @"revision";
NSString * SKUserActivityTimelineTypeBadge = @"badge";
NSString * SKUserActivityTimelineTypeAskOrAnswered = @"askoranswered";
NSString * SKUserActivityTimelineTypeAccepted = @"accepted";

//post constants
NSString * SKPostQuestion = @"question";
NSString * SKPostAnswer = @"answer";

NSString * SKUserActivityFromDateKey = @"fromdate";
NSString * SKUserActivityToDateKey = @"todate";

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
									@"type", SKUserActivityType,
									@"postID", SKUserActivityPostID,
									@"postType", SKUserActivityPostType,
									@"commentID", SKUserActivityCommentID,
									@"action", SKUserActivityAction,
									@"creationDate", SKUserActivityCreationDate,
									@"activityDescription", SKUserActivityDescription,
									@"activityDetail", SKUserActivityDetail,
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
	
	NSArray * datePredicates = [[request predicate] subPredicatesWithLeftExpression:[NSExpression expressionForKeyPath:SKUserActivityCreationDate]];
	if ([datePredicates count] > 0) {
		//find the first predicate with either > or >= as the operator.  this is our fromdate
		NSComparisonPredicate * fromdatePredicate = nil;
		for (NSComparisonPredicate * predicate in datePredicates) {
			if ([predicate predicateOperatorType] == NSGreaterThanPredicateOperatorType || 
				[predicate predicateOperatorType] == NSGreaterThanOrEqualToPredicateOperatorType) {
				fromdatePredicate = predicate;
				break;
			}
		}
		if (fromdatePredicate != nil && [[fromdatePredicate rightExpression] expressionType] == NSConstantValueExpressionType) {
			//we have a fromdate!
			id constantValue = [[fromdatePredicate rightExpression] constantValue];
			if ([constantValue isKindOfClass:[NSDate class]]) {
				NSTimeInterval fromDate = [(NSDate *)constantValue timeIntervalSince1970];
				[query setObject:[NSNumber numberWithDouble:fromDate] forKey:SKUserActivityFromDateKey];
			}
		}
		
		//find the first predicate with either < or <= as the operator.  this is our todate
		NSComparisonPredicate * todatePredicate = nil;
		for (NSComparisonPredicate * predicate in datePredicates) {
			if ([predicate predicateOperatorType] == NSLessThanPredicateOperatorType ||
				[predicate predicateOperatorType] == NSLessThanOrEqualToPredicateOperatorType) {
				todatePredicate = predicate;
				break;
			}
		}
		if (todatePredicate != nil && [[todatePredicate rightExpression] expressionType] == NSConstantValueExpressionType) {
			//we have a todate!
			id constantValue = [[todatePredicate rightExpression] constantValue];
			if ([constantValue isKindOfClass:[NSDate class]]) {
				NSTimeInterval toDate = [(NSDate *)constantValue timeIntervalSince1970];
				[query setObject:[NSNumber numberWithDouble:toDate] forKey:SKUserActivityToDateKey];
			}
		}
	}
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:relativeString query:query];
	
	return apiCall;
}

+ (NSPredicate *) updatedPredicateForFetchRequest:(SKFetchRequest *)request {
	return [[request predicate] predicateByRemovingSubPredicateWithLeftExpression:[NSExpression expressionForKeyPath:SKUserID]];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		NSString * dAction = [dictionary objectForKey:SKUserActivityAction];
		if ([dAction isEqual:SKUserActivityActionAnswered]) {
			action = SKUserActivityActionTypeAnswered;
		} else if ([dAction isEqual:SKUserActivityActionAwarded]) {
			action = SKUserActivityActionTypeAwarded;
		} else if ([dAction isEqual:SKUserActivityActionRevised]) {
			action = SKUserActivityActionTypeRevised;
		} else if ([dAction isEqual:SKUserActivityActionComment]) {
			action = SKUserActivityActionTypeComment;
		}
		
		NSString * timelineType = [dictionary objectForKey:SKUserActivityType];
		if ([timelineType isEqual:SKUserActivityTimelineTypeBadge]) {
			type = SKUserActivityTypeBadge;
		} else if ([timelineType isEqual:SKUserActivityTimelineTypeAccepted]) {
			type = SKUserActivityTypeAccepted;
		} else if ([timelineType isEqual:SKUserActivityTimelineTypeAskOrAnswered]) {
			type = SKUserActivityTypeAskOrAnswered;
		} else if ([timelineType isEqual:SKUserActivityTimelineTypeComment]) {
			type = SKUserActivityTypeComment;
		} else if ([timelineType isEqual:SKUserActivityTimelineTypeRevision]) {
			type = SKUserActivityTypeRevision;
		}
		
		if ([dictionary objectForKey:SKUserActivityPostID] != nil) {
			postID = [[dictionary objectForKey:SKUserActivityPostID] retain];
		}
		
		NSString * dPostType = [dictionary objectForKey:SKUserActivityPostType];
		if ([dPostType isEqual:SKPostQuestion]) {
			postType = SKPostTypeQuestion;
		} else if ([dPostType isEqual:SKPostAnswer]) {
			postType = SKPostTypeAnswer;
		}
		
		if ([dictionary objectForKey:SKUserActivityCommentID] != nil) {
			commentID = [[dictionary objectForKey:SKUserActivityCommentID] retain];
		}
		
		if ([dictionary objectForKey:SKUserActivityDescription] != nil) {
			activityDescription = [[dictionary objectForKey:SKUserActivityDescription] retain];
		}
		
		if ([dictionary objectForKey:SKUserActivityDetail] != nil) {
			activityDetail = [[dictionary objectForKey:SKUserActivityDetail] retain];
		}
		
		creationDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserActivityCreationDate] doubleValue]];
	}
	return self;
}

- (void) dealloc {
	[postID release];
	[commentID release];
	[activityDescription release];
	[activityDetail release];
	[creationDate release];
	[super dealloc];
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([self type] == [(SKUserActivity *)object type] &&
			[self action] == [(SKUserActivity *)object action] &&
			[[self creationDate] isEqualToDate:[object creationDate]]			
			);
}

@end
