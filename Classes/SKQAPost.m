// 
//  SKQAPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKQAPost.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"
#import "SKComment.h"

@implementation SKQAPost 

@dynamic communityOwned;
@dynamic downVotes;
@dynamic lastActivityDate;
@dynamic lastEditDate;
@dynamic lockedDate;
@dynamic title;
@dynamic upVotes;
@dynamic viewCount;

@dynamic comments;

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"communityOwned", SKAPICommunity_Owned,
                                                                  @"downVotes", SKAPIDown_Vote_Count,
                                                                  @"lastActivityDate", SKAPILast_Activity_Date,
                                                                  @"lastEditDate", SKAPILast_Edit_Date,
                                                                  @"lockedDate", SKAPILocked_Date,
                                                                  @"title", SKAPITitle,
                                                                  @"upVotes", SKAPIUp_Vote_Count,
                                                                  @"viewCount", SKAPIView_Count,
                                                                  @"comments", SKAPIComments,
                                                                  nil]];
    }
    return mapping;
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    if ([relationship isEqual:@"comments"]) {
        return [SKComment objectMergedWithDictionary:value inSite:[self site]];
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

@end
