// 
//  SKComment.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKComment.h"
#import "SKObject+Private.h"
#import "SKQAPost.h"
#import "SKUser.h"
#import "SKConstants_Internal.h"

@implementation SKComment 

@dynamic editCount;
@dynamic post;
@dynamic directedToUser;

+ (NSString *) apiResponseDataKey {
	return @"comments";
}

+ (NSString *) apiResponseUniqueIDKey {
	return SKAPIComment_ID;
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[super APIAttributeToPropertyMapping] mutableCopy];
        [(NSMutableDictionary *)mapping addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"postID", SKAPIComment_ID,
                                                                  @"editCount", SKAPIEdit_Count,
                                                                  @"post", SKAPIPost_ID,
                                                                  @"directedToUser", SKAPIReply_To_User,
                                                                  nil]];
    }
    return mapping;
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    if ([relationship isEqual:@"directedToUser"]) {
        return [SKUser objectMergedWithDictionary:value inSite:[self site]];
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

- (NSNumber *) commentID {
    return [self postID];
}

@end
