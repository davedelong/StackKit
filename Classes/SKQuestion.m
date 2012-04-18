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
#import "SKMacros.h"

#import "SKTag.h"
#import "SKAnswer.h"

@implementation SKQuestion 

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"postID", SKAPIQuestion_ID, // inherited from SKPost
                                                                  @"closeDate", SKAPIClosed_Date,
																  @"acceptedAnswerID", SKAPIAccepted_Answer_ID,
																  @"answerCount", SKAPIAnswer_Count,
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
        return [SKTag objectMergedWithDictionary:[NSDictionary dictionaryWithObject:value forKey:SKAPIName] inSite:[self site]];
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

- (NSNumber *)questionID {
    return [self postID];
}

SK_GETTER(NSNumber *, acceptedAnswerID);
SK_GETTER(NSNumber *, answerCount);
SK_GETTER(NSDate *, closeDate);
SK_GETTER(NSNumber *, bountyAmount);
SK_GETTER(NSDate *, bountyCloseDate);
SK_GETTER(NSString *, closeReason);
SK_GETTER(NSNumber *, favoriteCount);
SK_GETTER(NSSet*, answers);
SK_GETTER(NSSet*, tags);
SK_GETTER(NSSet*, favoritedByUsers);

@end
