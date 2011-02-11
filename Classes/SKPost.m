// 
//  SKPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKPost.h"
#import "SKConstants_Internal.h"
#import "SKObject+Private.h"
#import "SKUser.h"

@implementation SKPost 

@dynamic body;
@dynamic creationDate;
@dynamic score;
@dynamic postID;
@dynamic owner;
@dynamic postActivity;

+ (NSDictionary *)APIAttributeToPropertyMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"creationDate", SKAPICreation_Date,
                   @"owner", SKAPIOwner,
                   @"body", SKAPIBody,
                   @"score", SKAPIScore,
                   nil];
    }
    return mapping;
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    if ([relationship isEqual:@"owner"]) {
        return [SKUser objectMergedWithDictionary:value inSite:[self site]];
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

@end
