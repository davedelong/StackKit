//
//  SKTypes.h
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SKSomething)(NSArray *);
typedef void(^SKErrorHandler)(NSError *);

extern NSString *const SKErrorDomain;

typedef enum {
    SKErrorCodeBadParameter = 400,
    SKErrorCodeInvalidMethod = 404,
    SKErrorCodeKeyRequired = 405,
    SKErrorCodeAccessDenied = 403,
    SKErrorCodeAccessTokenMissing = 401,
    SKErrorCodeAccessTokenInvalid = 402,
    SKErrorCodeAccessTokenCompromised = 406,
    SKErrorCodeThrottleViolation = 502,
    SKErrorCodeInternalError = 500
} SKErrorCode;
