//
//  SKUser.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKTypes.h>
#import <StackKit/SKObject.h>

@interface SKUser : SKObject

@property (readonly) NSUInteger userID;
@property (readonly) NSDate *creationDate;
@property (readonly) NSDate *lastModifiedDate;
@property (readonly) NSUInteger reputation;
@property (readonly) SKUserType userType;

@property (readonly) NSString *displayName;
@property (readonly) NSString *about;
@property (readonly) NSString *location;
@property (readonly) NSURL *profileImageURL;
@property (readonly) NSURL *websiteURL;

@end
