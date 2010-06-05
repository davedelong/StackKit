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
NSString * const SKCommentCreationDate = __SKPostCreationDate;
NSString * const SKCommentOwner = __SKPostOwner;
NSString * const SKCommentBody = __SKPostBody;
NSString * const SKCommentScore = __SKPostScore;

NSString * const SKCommentID = @"comment_id";
NSString * const SKCommentInReplyToUser = @"reply_to_user";
NSString * const SKCommentPost = @"post_id";
NSString * const SKCommentPostType = @"post_type";
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

+ (NSArray *) endpoints {
	return [NSArray arrayWithObjects:
			[SKSpecificCommentEndpoint class],
			[SKUserCommentsEndpoint class],
			[SKCommentsFromUserToUserEndpoint class],
			[SKCommentsToUserEndpoint class],
			[SKPostCommentsEndpoint class],
			nil];
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
