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
	 
	 /questions/{id}/comments
	 /answers/{id}/comments
	 /users/{id}/comments/{toid}
	 
	 /comments/{id}
	 /users/{id}/comments
	 /users/{id}/mentioned
	 
	 This means the valid predicates are (respectively):
	 
	 SKCommentPost = ## AND SKCommentPostType = SKPostTypeQuestion
	 SKCommentPost = ## AND SKCommentPostType = SKPostTypeAnswer
	 SKPostOwner = ## AND SKCommentInReplyToUser = ##
	 
	 SKCommentID = ##
	 SKPostOwner = ##
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
		
	} else if ([p isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compoundP = (NSCompoundPredicate *)p;
		if ([compoundP compoundPredicateType] != NSAndPredicateType) {
			return invalidPredicateErrorForFetchRequest(request, nil);
		}
		
		/**
		 it's one of:
		 SKCommentPost = ## AND SKCommentPostType = SKPostTypeQuestion
		 SKCommentPost = ## AND SKCommentPostType = SKPostTypeAnswer
		 SKPostOwner = ## AND SKCommentInReplyToUser = ##
		 **/
		NSArray * subpredicates = [compoundP subpredicates];
		if ([subpredicates count] != 2) {
			return invalidPredicateErrorForFetchRequest(request, nil);
		}
		
		NSPredicate * first = [subpredicates objectAtIndex:0];
		NSPredicate * second = [subpredicates objectAtIndex:1];
		
		BOOL hasCommentPost = ([first isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentPost] || [second isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentPost]);
		BOOL hasCommentPostType = ([first isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentPostType] || [second isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentPostType]);
		BOOL hasPostOwner = ([first isPredicateWithConstantValueEqualToLeftKeyPath:SKPostOwner] || [second isPredicateWithConstantValueEqualToLeftKeyPath:SKPostOwner]);
		BOOL hasReplyTo = ([first isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentInReplyToUser] || [second isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentInReplyToUser]);
		
		if (hasCommentPost && hasCommentPostType) {
			id post = [first constantValueForLeftKeyPath:SKCommentPost];
			if (post == nil) { post = [second constantValueForLeftKeyPath:SKCommentPost]; }
			
			id type = [first constantValueForLeftKeyPath:SKCommentPostType];
			if (type == nil) { type = [second constantValueForLeftKeyPath:SKCommentPostType]; }
			
			if (post == nil || type == nil) {
				//this should never happen, but just in case...
				return invalidPredicateErrorForFetchRequest(request, nil);
			}
			
			SKPostType_t postType = [type intValue];
			if (postType != SKPostTypeQuestion && postType != SKPostTypeAnswer) {
				return invalidPredicateErrorForFetchRequest(request, nil);
			}
			
			NSNumber * postID = SKExtractPostID(post);
			path = [NSString stringWithFormat:@"/%@/%@/comments", (postType == SKPostTypeQuestion ? @"questions" : @"answers"), postID];
		} else if (hasPostOwner && hasReplyTo) {
			id owner = [first constantValueForLeftKeyPath:SKPostOwner];
			if (owner == nil) { owner = [second constantValueForLeftKeyPath:SKPostOwner]; }
			
			id replyTo = [first constantValueForLeftKeyPath:SKCommentInReplyToUser];
			if (replyTo == nil) { replyTo = [second constantValueForLeftKeyPath:SKCommentInReplyToUser]; }
			
			if (owner == nil || replyTo == nil) {
				return invalidPredicateErrorForFetchRequest(request, nil);
			}
			
			NSNumber * ownerID = SKExtractUserID(owner);
			NSNumber * replyToID = SKExtractUserID(replyTo);
			
			path = [NSString stringWithFormat:@"/users/%@/comments/%@", ownerID, replyToID];
		} else {
			return invalidPredicateErrorForFetchRequest(request, nil);
		}
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
