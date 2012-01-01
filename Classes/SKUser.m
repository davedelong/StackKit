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

@implementation SKUser

@dynamic userID;
@dynamic creationDate;
@dynamic lastModifiedDate;

@dynamic displayName;
@dynamic about;
@dynamic location;
@dynamic websiteURL;

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *keys = nil;
    dispatch_once(&onceToken, ^{
        keys = [[NSArray alloc] initWithObjects:
                SKAPIKeys.user.userID,
                SKAPIKeys.user.creationDate,
                SKAPIKeys.user.lastModifiedDate,
                
                SKAPIKeys.user.displayName,
                SKAPIKeys.user.aboutMe,
                SKAPIKeys.user.location,
                SKAPIKeys.user.profileImage,
                SKAPIKeys.user.websiteURL,
                nil];
    });
    return keys;
}

// why isn't this @dynamic'd?
// because "profile_image" => "profileImage" implies an NS/UIImage return type
// but the type is actually a URL
// and there's no easy way to infer that
// thus it's done manually
- (NSURL *)profileImageURL {
    return [NSURL URLWithString:[self _valueForInfoKey:SKAPIKeys.user.profileImage]];
}

- (NSUInteger)reputation {
    id value = [self _valueForInfoKey:NSStringFromSelector(_cmd)];
    return [value unsignedIntegerValue];
}

- (SKUserType)userType {
    id value = [self _valueForInfoKey:NSStringFromSelector(_cmd)];
    
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
