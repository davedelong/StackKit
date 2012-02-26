//
//  SKTypes.h
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKObject, SKSite;

typedef void(^SKRequestHandler)(NSArray *, NSError *);
typedef void(^SKObjectHandler)(SKObject *, NSError *);
typedef void(^SKSiteHandler)(SKSite *, NSError *);
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
    SKErrorCodeInternalError = 500,
    
    SKErrorCodeAuthenticationInProgress = 1000,
    SKErrorCodeAuthenticationCancelled = 1001,
    SKErrorCodeAuthenticatedAlready = 1002,
    
    SKErrorCodeInvalidObject = 1010,
    SKErrorCodeInvalidRequest = 1011
} SKErrorCode;

typedef enum {
	SKSiteStateNormal = 0,
	SKSiteStateLinkedMeta = 1,
	SKSiteStateOpenBeta = 2,
	SKSiteStateClosedBeta = 3
} SKSiteState;

typedef enum {
	SKUserTypeAnonymous = 0,
	SKUserTypeUnregistered = 1,
	SKUserTypeRegistered = 2,
	SKUserTypeModerator = 3
} SKUserType;

typedef enum {
    SKBadgeRankGold = 0,
    SKBadgeRankSilver = 1,
    SKBadgeRankBronze = 2
} SKBadgeRank;

typedef enum {
    SKPostTypeAnswer,
    SKPostTypeQuestion,
    SKPostTypeComment
} SKPostType;
