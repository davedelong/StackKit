//
//  SKQuestion+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKQuestion+Private.h"
#import "SKObject+Private.h"
#import "SKQuestion.h"
#import "SKTag.h"

NSString * const SKQuestionsFavoritedByUser = @"question_favorited_by_user";
NSString * const SKQuestionFavoritedDate = @"question_favorited_date";

@implementation SKQuestion (Private)

@dynamic closeDate;
@dynamic bountyAmount;
@dynamic bountyCloseDate;
@dynamic closeReason;
@dynamic favoriteCount;
@dynamic answers;
@dynamic tags;

+ (NSString *) apiResponseDataKey {
	return @"questions";
}

+ (NSString *) apiResponseUniqueIDKey {
	return SKQuestionID;
}

- (void) mergeInformationFromAPIResponseDictionary:(NSDictionary *)dictionary {
	[super mergeInformationFromAPIResponseDictionary:dictionary];
	
	[self setCloseDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKQuestionCloseDate] doubleValue]]];
	[self setBountyAmount:[dictionary objectForKey:SKQuestionBountyAmount]];
	[self setBountyCloseDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKQuestionBountyCloseDate] doubleValue]]];
	[self setCloseReason:[dictionary objectForKey:SKQuestionCloseReason]];
	
	[self setFavoriteCount:[dictionary objectForKey:SKQuestionFavoriteCount]];
	
	//TODO: merge tags and answers
	/**
	NSArray * tagNames = [dictionary objectForKey:SKQuestionTags];
	tags = [[NSMutableArray alloc] initWithCapacity:[tagNames count]];
	for (NSString * name in tagNames) {
		NSDictionary * tagDictionary = [NSDictionary dictionaryWithObject:name forKey:SKTagName];
		SKTag * tag = [[SKTag alloc] initWithSite:aSite dictionaryRepresentation:tagDictionary];
		[(NSMutableArray *)tags addObject:tag];
		[tag release];
	}
	 **/
}

@end
