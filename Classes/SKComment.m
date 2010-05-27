//
//  SKComment.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * const SKCommentID = @"comment_id";
NSString * const SKCommentInReplyToUser = @"reply_to_user";
NSString * const SKCommentPost = @"post_id";
NSString * const SKCommentPostType = @"post_type";
NSString * const SKCommentScore = @"score";
NSString * const SKCommentEditCount = @"edit_count";

@implementation SKComment

@synthesize commentID;
@synthesize replyToUserID;
@synthesize postID;
@synthesize postType;
@synthesize score;
@synthesize editCount;

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	/**
	 valid endpoints:
	 
	 /answers/{id}/comments
	 /comments/{id}
	 /questions/{id}/comments
	 /users/{id}/comments
	 /users/{id}/comments/{toid}
	 /users/{id}/mentioned
	 
	 This means the valid predicates are:
	 
	 SKCommentPost = ## AND SKCommentPostType = SKPostTypeQuestion
	 SKCommentPost = ## AND SKCommentPostType = SKPostTypeAnswer
	 SKCommentID = ##
	 SKPostOwner = ##
	 SKPostOwner = ## AND SKCommentInReplyToUser = ##
	 SKCommentInReplyToUser = ##
	 
	 **/
	
	NSString * path = nil;
	
	//this *must* have a predicate
	NSPredicate * p = [request predicate];
	if (p == nil) {
		return invalidPredicateErrorForFetchRequest(request, nil);
	}
	
	if ([p isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate * comparisonP = (NSComparisonPredicate *)p;
		NSArray * validKeyPaths = [NSArray arrayWithObjects:SKCommentID, SKPostOwner, SKCommentInReplyToUser, nil];
		if ([comparisonP isComparisonPredicateWithLeftKeyPaths:validKeyPaths 
													  operator:NSEqualToPredicateOperatorType 
										   rightExpressionType:NSConstantValueExpressionType] == NO) {
			return invalidPredicateErrorForFetchRequest(request, nil);
		}
		
		/**
		 it's one of:
		 SKCommentID = ##
		 SKPostOwner = ##
		 SKCommentInReplyToUser = ##
		 **/
	}
	
	return nil; //for now
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										@"commentID", SKCommentID,
										@"replyToUserID", SKCommentInReplyToUser,
										@"postID", SKCommentPost,
										@"postType", SKCommentPostType,
										@"editCount", SKCommentEditCount,
										nil];
	[dictionary addEntriesFromDictionary:[super APIAttributeToPropertyMapping]];
	return dictionary;
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite dictionaryRepresentation:dictionary]) {
		commentID = [[dictionary objectForKey:SKCommentID] retain];
		postID = [[dictionary objectForKey:SKCommentPost] retain];
		score = [[dictionary objectForKey:SKCommentScore] retain];
		postType = ([[dictionary objectForKey:SKCommentPostType] isEqual:@"question"] ? SKPostTypeQuestion : SKPostTypeAnswer);
		
		//these are optional
		editCount = [[dictionary objectForKey:SKCommentEditCount] retain];
		
		NSDictionary * replyToDictionary = [dictionary objectForKey:SKCommentInReplyToUser];
		if (replyToDictionary != nil) {
			replyToUserID = [[replyToDictionary objectForKey:SKUserID] retain];
		}
	}
	return self;
}

- (void) dealloc {
	[commentID release];
	[postID release];
	[score release];
	[editCount release];
	[replyToUserID release];
	[super dealloc];
}

- (SKUser *) replyToUser {
	return [[self site] userWithID:[self replyToUserID]];
}

- (SKPost *) post {
	if (postType == SKPostTypeAnswer) {
		//TODO: interpret postID as an SKAnswerID
	} else {
		//TODO: interpret postID as an SKQuestionID
	}
	return nil;
}

@end
