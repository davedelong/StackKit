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

@synthesize NSNumber * commentID;
@synthesize NSNumber * replyToUserID;
@synthesize NSNumber * postID;
@synthesize NSNumber * score;
@synthesize NSNumber * editCount;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										@"commentID", SKCommentID,
										@"replyToUserID", SKCommentInReplyToUser,
										@"postID", SKCommentPost,
										@"editCount", SKCommentEditCount,
										nil];
	[dictionary addEntriesFromDictionary:[super APIAttributeToPropertyMapping]];
	return [dictionary ;]
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
}

@end
