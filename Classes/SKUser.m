//
//  SKUser.m
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKUser.h"
#import <CoreData/CoreData.h>
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKMacros.h>

@implementation SKUser

@dynamic userID;
@dynamic creationDate;
@dynamic lastModifiedDate;
@dynamic reputation;

@dynamic displayName;
@dynamic about;
@dynamic location;
@dynamic websiteURL;
@dynamic profileImageURL;

+ (NSString *)_uniquelyIdentifyingAPIKey {
    return SKAPIKeys.user.userID;
}

+ (NSString *)inferredPropertyNameFromAPIKey:(NSString *)apiKey {
    if ([apiKey isEqualToString:SKAPIKeys.user.profileImage]) {
        return PROPERTY(profileImageURL);
    }
    return [super inferredPropertyNameFromAPIKey:apiKey];
}

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *keys = nil;
    dispatch_once(&onceToken, ^{
        keys = [[NSArray alloc] initWithObjects:
                SKAPIKeys.user.userID,
                SKAPIKeys.user.creationDate,
                SKAPIKeys.user.lastModifiedDate,
                SKAPIKeys.user.reputation,
                
                SKAPIKeys.user.displayName,
                SKAPIKeys.user.aboutMe,
                SKAPIKeys.user.location,
                SKAPIKeys.user.profileImage,
                SKAPIKeys.user.websiteURL,
                nil];
    });
    return keys;
}

- (SKUserType)userType {
    id value = [self _valueForInfoKey:SKAPIKeys.user.userType];
    
    SKUserType t = SKUserTypeRegistered;
    if ([value isEqual:@"moderator"]) {
        t = SKUserTypeModerator;
    } else if ([value isEqual:@"unregistered"]) {
        t = SKUserTypeUnregistered;
    } else if ([value isEqual:@"does_not_exist"]) {
        t = SKUserTypeAnonymous;
    }
    
    return t;
}

@end
