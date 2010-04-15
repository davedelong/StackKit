//
//  SKConstants.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SKConstants.h"

NSString * SKAPIKey = @"speakfriendandenter";
NSString * SKAPIVersion = @"0.6";

NSUInteger SKPageSizeLimitMax = 100;
NSString * SKPageKey = @"page";
NSString * SKPageSizeKey = @"pagesize";

NSString * SKSortKey = @"sort";
NSString * SKSortOrderKey = @"order";

#pragma mark -
#pragma mark Statistics Keys
NSString * SKStatsTotalQuestions = @"total_questions";
NSString * SKStatsTotalUnansweredQuestions = @"total_unanswered";
NSString * SKStatsTotalAnswers = @"total_answers";
NSString * SKStatsTotalComments = @"total_comments";
NSString * SKStatsTotalVotes = @"total_votes";
NSString * SKStatsTotalBadges = @"total_badges";
NSString * SKStatsTotalUsers = @"total_users";
NSString * SKStatsQuestionsPerMinute = @"questions_per_minute";
NSString * SKStatsAnswersPerMinutes = @"answers_per_minute";
NSString * SKStatsBadgesPerMinute = @"badges_per_minute";

NSString * SKStatsAPIInfo = @"api_version";
NSString * SKStatsAPIInfoVersion = @"version";
NSString * SKStatsAPIInfoRevision = @"revision";	

#pragma mark -
#pragma mark Error Constants
NSString * SKErrorDomain = @"com.github.davedelong.stackkit";

#pragma mark Error codes
NSUInteger SKErrorCodeNotImplemented = 1;
NSUInteger SKErrorCodeInvalidEntity = 2;
NSUInteger SKErrorCodeInvalidPredicate = 3;