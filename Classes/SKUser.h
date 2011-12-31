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

@property (nonatomic, readonly) NSUInteger userID;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSDate *lastModifiedDate;
@property (nonatomic, readonly) NSUInteger reputation;
@property (nonatomic, readonly) SKUserType userType;

@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *about;
@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) NSURL *profileImageURL;
@property (nonatomic, readonly) NSURL *websiteURL;

@end
