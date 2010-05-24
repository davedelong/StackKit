//
//  SKConstants.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKConstants.h"

NSString * const SKAPIVersion = @"0.8";

NSUInteger const SKPageSizeLimitMax = 100;
NSString * const SKPageKey = @"page";
NSString * const SKPageSizeKey = @"pagesize";

NSString * const SKSortKey = @"sort";
NSString * const SKSortOrderKey = @"order";

#pragma mark -
#pragma mark Statistics Keys
NSString * const SKStatsTotalQuestions = @"total_questions";
NSString * const SKStatsTotalUnansweredQuestions = @"total_unanswered";
NSString * const SKStatsTotalAnswers = @"total_answers";
NSString * const SKStatsTotalComments = @"total_comments";
NSString * const SKStatsTotalVotes = @"total_votes";
NSString * const SKStatsTotalBadges = @"total_badges";
NSString * const SKStatsTotalUsers = @"total_users";
NSString * const SKStatsQuestionsPerMinute = @"questions_per_minute";
NSString * const SKStatsAnswersPerMinutes = @"answers_per_minute";
NSString * const SKStatsBadgesPerMinute = @"badges_per_minute";

NSString * const SKStatsAPIInfo = @"api_version";
NSString * const SKStatsAPIInfoVersion = @"version";
NSString * const SKStatsAPIInfoRevision = @"revision";	

#pragma mark -
#pragma mark Error Constants
NSString * const SKErrorDomain = @"com.github.davedelong.stackkit";
NSString * const SKExceptionInvalidDelegate = @"com.github.davedelong.stackkit.skfetchrequest.delegate";

#pragma mark Error codes
NSUInteger const SKErrorCodeNotImplemented = 1;
NSUInteger const SKErrorCodeInvalidEntity = 2;
NSUInteger const SKErrorCodeInvalidPredicate = 3;

NSInteger const SKErrorCodeNotFound = 404;
NSInteger const SKErrorCodeInternalServerError = 500;
NSInteger const SKErrorCodeInvalidApplicationPublicKey = 4000;
NSInteger const SKErrorCodeInvalidPageSize = 4001;
NSInteger const SKErrorCodeInvalidSort = 4002;
NSInteger const SKErrorCodeInvalidOrder = 4003;