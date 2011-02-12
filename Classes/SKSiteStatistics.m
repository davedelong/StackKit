//
//  SKSiteStats.m
//  StackKit
//
//  Created by Alex Rozanski on 12/02/2011.
//  Copyright 2011 Alex Rozanski. All rights reserved.
//

#import "SKSiteStatistics.h"


@implementation SKSiteStatistics

@synthesize site = _site;
@synthesize totalQuestions = _totalQuestions, totalUnansweredQuestions = _totalUnansweredQuestions, totalAcceptedAnswers = _totalAcceptedAnswers;
@synthesize totalAnswers = _totalAnswers, totalComments = _totalComments, totalVotes = _totalVotes, totalBadges = _totalBadges, totalUsers = _totalUsers;
@synthesize questionsPerMinute = _questionsPerMinute, answersPerMinute = _answersPerMinute, badgesPerMinute = _badgesPerMinute;
@synthesize viewsPerDay = _viewsPerDay;

#pragma mark - 
#pragma mark Init/Dealloc

- (id)initWithSite:(SKSite *)site responseDictionary:(NSDictionary *)responseDictionary
{
    self = [super init];
    if (self) {
        _site = [site retain];
        _totalQuestions = [[responseDictionary objectForKey:@"total_questions"] retain];
        _totalUnansweredQuestions = [[responseDictionary objectForKey:@"total_unanswered"] retain];
        _totalAcceptedAnswers = [[responseDictionary objectForKey:@"total_accepted"] retain];
        _totalAnswers = [[responseDictionary objectForKey:@"total_answers"] retain];
        _totalComments = [[responseDictionary objectForKey:@"total_comments"] retain];
        _totalVotes = [[responseDictionary objectForKey:@"total_votes"] retain];
        _totalBadges = [[responseDictionary objectForKey:@"total_badges"] retain];
        _totalUsers = [[responseDictionary objectForKey:@"total_users"] retain];
        _questionsPerMinute = [[responseDictionary objectForKey:@"questions_per_minute"] retain];
        _answersPerMinute = [[responseDictionary objectForKey:@"answers_per_minute"] retain];
        _badgesPerMinute = [[responseDictionary objectForKey:@"badges_per_minute"] retain];
        _viewsPerDay = [[responseDictionary objectForKey:@"views_per_day"] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_site release];
    [_totalQuestions release];
    [_totalUnansweredQuestions release];
    [_totalAcceptedAnswers release];
    [_totalAnswers release];
    [_totalComments release];
    [_totalVotes release];
    [_totalBadges release];
    [_totalUsers release];
    [_questionsPerMinute release];
    [_answersPerMinute release];
    [_badgesPerMinute release];
    [_viewsPerDay release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Instantiating

+ (id)statsForSite:(SKSite*)site withResponseDictionary:(NSDictionary*)responseDictionary
{
    SKSiteStatistics *stats = [[SKSiteStatistics alloc] initWithSite:site responseDictionary:responseDictionary];
    
    return [stats autorelease];
}

@end
