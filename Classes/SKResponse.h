//
//  SKResponse.h
//  StackKit
//
//  Created by Dave DeLong on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKResponse : NSObject

+ (id)responseFromJSON:(NSDictionary *)json error:(NSError *)error;

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) BOOL hasMore;
@property (nonatomic, readonly) NSDate *backoffDate;

@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSInteger errorID;
@property (nonatomic, readonly) NSString *errorName;
@property (nonatomic, readonly) NSString *errorMessage;

@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger pageSize;

@property (nonatomic, readonly) NSInteger quotaMax;
@property (nonatomic, readonly) NSInteger quotaRemaining;

@property (nonatomic, readonly) NSInteger total;
@property (nonatomic, readonly) NSString *type;

@end
