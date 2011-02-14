//
//  SKFavoritedQuestion.m
//  StackKit
//
//  Created by Dave DeLong on 2/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKFavoritedQuestion.h"
#import "SKQuestion.h"
#import "SKUser.h"
#import "SKObject+Private.h"
#import "SKConstants_Internal.h"
#import "SKMacros.h"

@implementation SKFavoritedQuestion

+ (NSDictionary *) APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"favoritedDate", SKAPIFavorited_Date,
                   @"user", SKAPIUser,
                   @"question", SKAPIQuestion_ID,
                   nil];
    }
    return mapping;
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    if ([relationship isEqualToString:@"user"]) {
        return [SKUser objectMergedWithDictionary:value inSite:[self site]];
    } else if ([relationship isEqualToString:@"question"]) {
        return [SKQuestion objectMergedWithDictionary:value inSite:[self site]];
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

SK_GETTER(NSDate *, favoritedDate);
SK_GETTER(SKUser *, user);
SK_GETTER(SKQuestion *, question);

@end
