//
//  SKConstants.h
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SKAPIKey;
extern NSString * const SKAPIVersion;

extern NSUInteger const SKPageSizeLimitMax;
extern NSString * const SKPageKey;
extern NSString * const SKPageSizeKey;

extern NSString * const SKSortKey;
extern NSString * const SKSortOrderKey;

#pragma mark -
#pragma mark Statistics Keys
extern NSString * const SKStatsTotalQuestions;
extern NSString * const SKStatsTotalUnansweredQuestions;
extern NSString * const SKStatsTotalAnswers;
extern NSString * const SKStatsTotalComments;
extern NSString * const SKStatsTotalVotes;
extern NSString * const SKStatsTotalBadges;
extern NSString * const SKStatsTotalUsers;
extern NSString * const SKStatsQuestionsPerMinute;
extern NSString * const SKStatsAnswersPerMinutes;
extern NSString * const SKStatsBadgesPerMinute;

extern NSString * const SKStatsAPIInfo;
extern NSString * const SKStatsAPIInfoVersion;
extern NSString * const SKStatsAPIInfoRevision;

#pragma mark -
#pragma mark Error Constants
extern NSString * const SKErrorDomain;
extern NSString * const SKExceptionInvalidDelegate;

#pragma mark Error codes
extern NSUInteger const SKErrorCodeNotImplemented;
extern NSUInteger const SKErrorCodeInvalidEntity;
extern NSUInteger const SKErrorCodeInvalidPredicate;
extern NSUInteger const SKErrorCodeUnknownError;

extern NSInteger const SKErrorCodeNotFound;
extern NSInteger const SKErrorCodeInternalServerError;
extern NSInteger const SKErrorCodeInvalidApplicationPublicKey;
extern NSInteger const SKErrorCodeInvalidPageSize;
extern NSInteger const SKErrorCodeInvalidSort;
extern NSInteger const SKErrorCodeInvalidOrder;