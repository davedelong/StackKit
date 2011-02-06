//
//  SKComment+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKComment+Private.h"
#import "SKComment+Public.h"
#import "SKDefinitions.h"
#import "SKObject+Private.h"

NSString * const SKCommentPostType = @"post_type";

@implementation SKComment (Private)

@dynamic editCount;
@dynamic post;
@dynamic directedToUser;

+ (NSString *) apiResponseDataKey {
	return @"comments";
}

+ (NSString *) apiResponseUniqueIDKey {
	return SKCommentID;
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

- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary {
	[super mergeInformationFromAPIResponseDictionary:dictionary];
	[self setEditCount:[dictionary objectForKey:SKCommentEditCount]];

	//TODO: post and inReplyTo:
//	commentID = [[dictionary objectForKey:SKCommentID] retain];
	//		postID = [[dictionary objectForKey:SKCommentPost] retain];
//	postType = ([[dictionary objectForKey:SKCommentPostType] isEqual:@"question"] ? SKPostTypeQuestion : SKPostTypeAnswer);
	
	
	NSDictionary * replyToDictionary = [dictionary objectForKey:SKCommentInReplyToUser];
	if (replyToDictionary != nil) {
//		replyToUserID = [[replyToDictionary objectForKey:SKUserID] retain];
	}
}

@end
