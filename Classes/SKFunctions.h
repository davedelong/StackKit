//
//  SKFunctions.h
//  StackKit
//
//  Created by Dave DeLong on 5/26/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKFetchRequest;

id invalidPredicateErrorForFetchRequest(SKFetchRequest * request, NSDictionary * userInfo);

NSNumber * SKExtractUserID(id value);
NSNumber * SKExtractBadgeID(id value);
NSString * SKExtractTagName(id value);
NSNumber * SKExtractPostID(id value);