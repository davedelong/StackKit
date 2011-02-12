// 
//  SKQuestion.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKQuestion.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"

#import "SKTag.h"
#import "SKAnswer.h"

@implementation SKQuestion 

@dynamic closeDate;
@dynamic bountyAmount;
@dynamic bountyCloseDate;
@dynamic closeReason;
@dynamic favoriteCount;
@dynamic answers;
@dynamic tags;
@dynamic favoritedByUsers;

+ (NSString *) entityName {
    return @"SKQuestion";
}

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"postID", SKAPIQuestion_ID, // inherited from SKPost
                                                                  @"closeDate", SKAPIClosed_Date,
                                                                  @"bountyAmount", SKAPIBounty_Amount,
                                                                  @"bountyCloseDate", SKAPIBounty_Closes_Date,
                                                                  @"closeReason", SKAPIClosed_Reason,
                                                                  @"favoriteCount", SKAPIFavorite_Count,
                                                                  @"answers", SKAPIAnswers,
                                                                  @"tags", SKAPITags,
                                                                  nil]];
    }
    return mapping;
}

+ (NSString *)apiResponseDataKey {
    return @"questions";
}

+ (NSString *)apiResponseUniqueIDKey {
    return SKAPIQuestion_ID;
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    if ([relationship isEqual:@"answers"]) {
        return [SKAnswer objectMergedWithDictionary:value inSite:[self site]];
    } else if ([relationship isEqual:@"tags"]) {
        return [SKTag objectMergedWithDictionary:[NSDictionary dictionaryWithObject:value forKey:SKTagName] inSite:[self site]];
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

- (NSNumber *)questionID {
    return [self postID];
}

@end
