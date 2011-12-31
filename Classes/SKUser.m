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

@implementation SKUser

@dynamic userID;
@dynamic creationDate;

@dynamic displayName;
@dynamic about;
@dynamic location;
@dynamic profileImageURL;
@dynamic websiteURL;

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
