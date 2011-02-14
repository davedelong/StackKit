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
#import "SKMacros.h"

@implementation SKPost 

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

- (SKFetchRequest *) mergeRequest {
    SKFetchRequest *r = [[SKFetchRequest alloc] init];
    [r setEntity:[self class]];
    [r setPredicate:[NSPredicate predicateWithFormat:@"postID = %@", [self postID]]];
    
    return [r autorelease];
}

- (id)transformValueToMerge:(id)value forRelationship:(NSString *)relationship {
    if ([relationship isEqual:@"owner"]) {
        return [SKUser objectMergedWithDictionary:value inSite:[self site]];
    }
    return [super transformValueToMerge:value forRelationship:relationship];
}

SK_GETTER(NSString *, body);
SK_GETTER(NSDate *, creationDate);
SK_GETTER(NSNumber *, score);
SK_GETTER(NSNumber *, postID);
SK_GETTER(SKUser *, owner);
SK_GETTER(NSSet*, postActivity);

@end
