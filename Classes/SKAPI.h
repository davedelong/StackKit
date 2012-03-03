//
//  SKAPI.h
//  StackKit
//
//  Created by Dave DeLong on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SKAPITypeString;
extern NSString *const SKAPITypeInteger;
extern NSString *const SKAPITypeDate;

@interface SKAPI : NSObject

+ (id)api;

@property (readonly) NSArray *entities;
@property (readonly) NSDictionary *entitiesByName;

@end
