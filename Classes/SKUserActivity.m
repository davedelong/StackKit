//
//  SKUserActivity.m
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

NSString * const SKUserActivityType = @"timeline_type";
NSString * const SKUserActivityPostID = @"post_id";
NSString * const SKUserActivityPostType = @"post_type";
NSString * const SKUserActivityCommentID = @"comment_id";
NSString * const SKUserActivityAction = @"action";
NSString * const SKUserActivityCreationDate = @"creation_date";
NSString * const SKUserActivityDescription = @"description";
NSString * const SKUserActivityDetail = @"detail";

//internal

//actions
NSString * const SKUserActivityActionComment = @"comment";
NSString * const SKUserActivityActionRevised = @"revised";
NSString * const SKUserActivityActionAwarded = @"awarded";
NSString * const SKUserActivityActionAnswered = @"answered";

//timeline types
NSString * const SKUserActivityTimelineTypeComment = @"comment";
NSString * const SKUserActivityTimelineTypeRevision = @"revision";
NSString * const SKUserActivityTimelineTypeBadge = @"badge";
NSString * const SKUserActivityTimelineTypeAskOrAnswered = @"askoranswered";
NSString * const SKUserActivityTimelineTypeAccepted = @"accepted";

//post constants
NSString * const SKPostQuestion = @"question";
NSString * const SKPostAnswer = @"answer";

NSString * const SKUserActivityFromDateKey = @"fromdate";
NSString * const SKUserActivityToDateKey = @"todate";

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

+ (NSString *) dataKey {
	return @"user_timelines";
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
		
		creationDate = [[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKUserActivityCreationDate] doubleValue]] retain];
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
