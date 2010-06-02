//
//  SKComment.m
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

NSString * const SKCommentID = @"comment_id";
NSString * const SKCommentInReplyToUser = @"reply_to_user";
NSString * const SKCommentPost = @"post_id";
NSString * const SKCommentPostType = @"post_type";
NSString * const SKCommentScore = __SKPostScore;
NSString * const SKCommentEditCount = @"edit_count";

@implementation SKComment

@synthesize commentID;
@synthesize replyToUserID;
@synthesize postID;
@synthesize postType;
@synthesize editCount;

+ (NSString *) dataKey {
	return @"comments";
}

+ (NSDictionary *) validPredicateKeyPaths {
	NSMutableDictionary * d = [NSMutableDictionary dictionaryWithObjectsAndKeys:
							   SKCommentInReplyToUser, @"replyToUserID",
							   SKCommentPost, @"postID",
							   nil];
	[d addEntriesFromDictionary:[super validPredicateKeyPaths]];
	return d;
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	/**
	 valid endpoints:
	 
	 /users/{id}/comments/{toid}
	 
	 /questions/{id}/comments		|\__merged into /posts/{id}/comments
	 /answers/{id}/comments			|/
	 
	 /comments/{id}
	 /users/{id}/comments
	 /users/{id}/mentioned
	 
	 This means the valid predicates are (respectively):
	 
	 SKPostOwner = ## AND SKCommentInReplyToUser = ##
	 
	 SKCommentID = ##
	 SKPostOwner = ##
	 SKCommentPost = ##
	 SKCommentInReplyToUser = ##
	 
	 **/
	
	NSString * path = nil;
	
	//this *must* have a predicate
	NSPredicate * p = [request predicate];
	if (p == nil) {
		return SKInvalidPredicateErrorForFetchRequest(request, nil);
	}
	
	if ([p isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate * comparisonP = (NSComparisonPredicate *)p;
		NSArray * validKeyPaths = [NSArray arrayWithObjects:SKCommentID, SKPostOwner, SKCommentPost, SKCommentInReplyToUser, nil];
		if ([comparisonP isComparisonPredicateWithLeftKeyPaths:validKeyPaths 
													  operator:NSEqualToPredicateOperatorType 
										   rightExpressionType:NSConstantValueExpressionType] == NO) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		
		/**
		 it's one of:
		 SKCommentID = ##
		 SKPostOwner = ##
		 SKCommentPost = ##
		 SKCommentInReplyToUser = ##
		 **/
		id commentID = [comparisonP constantValueForLeftKeyPath:SKCommentID];
		id postOwner = [comparisonP constantValueForLeftKeyPath:SKPostOwner];
		id commentPost = [comparisonP constantValueForLeftKeyPath:SKCommentPost];
		id replyTo = [comparisonP constantValueForLeftKeyPath:SKCommentInReplyToUser];
		
		if (commentID != nil) {
			path = [NSString stringWithFormat:@"/comments/%@", SKExtractCommentID(commentID)];
		} else if (postOwner != nil) {
			path = [NSString stringWithFormat:@"/users/%@/comments", SKExtractUserID(postOwner)];
		} else if (commentPost != nil) {
			path = [NSString stringWithFormat:@"/posts/%@/comments", SKExtractPostID(commentPost)];
		} else if (replyTo != nil) {
			path = [NSString stringWithFormat:@"/users/%@/mentioned", SKExtractUserID(replyTo)];
		} else {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		
	} else if ([p isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compoundP = (NSCompoundPredicate *)p;
		if ([compoundP compoundPredicateType] != NSAndPredicateType) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		
		/**
		 SKPostOwner = ## AND SKCommentInReplyToUser = ##
		 **/
		NSArray * subpredicates = [compoundP subpredicates];
		if ([subpredicates count] != 2) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		
		NSPredicate * first = [subpredicates objectAtIndex:0];
		NSPredicate * second = [subpredicates objectAtIndex:1];
		
		BOOL hasPostOwner = ([first isPredicateWithConstantValueEqualToLeftKeyPath:SKPostOwner] || [second isPredicateWithConstantValueEqualToLeftKeyPath:SKPostOwner]);
		BOOL hasReplyTo = ([first isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentInReplyToUser] || [second isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentInReplyToUser]);
		
		if (hasPostOwner && hasReplyTo) {
			id owner = [first constantValueForLeftKeyPath:SKPostOwner];
			if (owner == nil) { owner = [second constantValueForLeftKeyPath:SKPostOwner]; }
			
			id replyTo = [first constantValueForLeftKeyPath:SKCommentInReplyToUser];
			if (replyTo == nil) { replyTo = [second constantValueForLeftKeyPath:SKCommentInReplyToUser]; }
			
			if (owner == nil || replyTo == nil) {
				return SKInvalidPredicateErrorForFetchRequest(request, nil);
			}
			
			NSNumber * ownerID = SKExtractUserID(owner);
			NSNumber * replyToID = SKExtractUserID(replyTo);
			
			path = [NSString stringWithFormat:@"/users/%@/comments/%@", ownerID, replyToID];
		} else {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
	}
	
	NSMutableDictionary * query = [request defaultQueryDictionary];
	
	return [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:path query:query];
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
