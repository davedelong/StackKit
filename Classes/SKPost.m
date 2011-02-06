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

NSString * const SKPostCreationDate = __SKPostCreationDate;
NSString * const SKPostOwner = __SKPostOwner;
NSString * const SKPostBody = __SKPostBody;
NSString * const SKPostScore = __SKPostScore;

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
                   @"creationDate", SKPostCreationDate,
                   @"owner", SKPostOwner,
                   @"body", SKPostBody,
                   @"score", SKPostScore,
                   nil];
    }
    return mapping;
}

@end
