//
//  SKConstants.h
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * SKAPIKey;
extern NSString * SKAPIVersion;

extern NSUInteger SKPageSizeLimitMax;
extern NSString * SKPageKey;
extern NSString * SKPageSizeKey;

extern NSString * SKSortKey;
extern NSString * SKSortOrderKey;

#pragma mark -
#pragma mark Statistics Keys
extern NSString * SKStatsTotalQuestions;
extern NSString * SKStatsTotalUnansweredQuestions;
extern NSString * SKStatsTotalAnswers;
extern NSString * SKStatsTotalComments;
extern NSString * SKStatsTotalVotes;
extern NSString * SKStatsTotalBadges;
extern NSString * SKStatsTotalUsers;
extern NSString * SKStatsQuestionsPerMinute;
extern NSString * SKStatsAnswersPerMinutes;
extern NSString * SKStatsBadgesPerMinute;

extern NSString * SKStatsAPIInfo;
extern NSString * SKStatsAPIInfoVersion;
extern NSString * SKStatsAPIInfoRevision;

#pragma mark -
#pragma mark Error Constants
extern NSString * SKErrorDomain;

#pragma mark Error codes
extern NSUInteger SKErrorCodeNotImplemented;
extern NSUInteger SKErrorCodeInvalidEntity;
extern NSUInteger SKErrorCodeInvalidPredicate;

extern NSInteger SKErrorCodeNotFound;
extern NSInteger SKErrorCodeInternalServerError;
extern NSInteger SKErrorCodeInvalidApplicationPublicKey;
extern NSInteger SKErrorCodeInvalidPageSize;
extern NSInteger SKErrorCodeInvalidSort;
extern NSInteger SKErrorCodeInvalidOrder;