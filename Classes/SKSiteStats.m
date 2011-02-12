//
//  SKSiteStats.m
//  StackKit
//
//  Created by Alex Rozanski on 12/02/2011.
//  Copyright 2011 Alex Rozanski. All rights reserved.
//

#import "SKSiteStats.h"


@implementation SKSiteStats

@synthesize site = _site;
@synthesize totalQuestions = _totalQuestions, totalUnansweredQuestions = _totalUnansweredQuestions, totalAcceptedAnswers = _totalAcceptedAnswers;
@synthesize totalAnswers = _totalAnswers, totalComments = _totalComments, totalVotes = _totalVotes, totalBadges = _totalBadges, totalUsers = _totalUsers;
@synthesize questionsPerMinute = _questionsPerMinute, answersPerMinute = _answersPerMinute, badgesPerMinute = _badgesPerMinute;
@synthesize viewsPerDay = _viewsPerDay;

#pragma mark - 
#pragma mark Init/Dealloc

- (id)init
{
    if((self = [super init])) {
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
    SKSiteStats *stats = [[[self alloc] init] autorelease];
    
    stats->_site = [site retain];
    stats->_totalQuestions = [[responseDictionary objectForKey:@"total_questions"] retain];
    stats->_totalUnansweredQuestions = [[responseDictionary objectForKey:@"total_unanswered"] retain];
    stats->_totalAcceptedAnswers = [[responseDictionary objectForKey:@"total_accepted"] retain];
    stats->_totalAnswers = [[responseDictionary objectForKey:@"total_answers"] retain];
    stats->_totalComments = [[responseDictionary objectForKey:@"total_comments"] retain];
    stats->_totalVotes = [[responseDictionary objectForKey:@"total_votes"] retain];
    stats->_totalBadges = [[responseDictionary objectForKey:@"total_badges"] retain];
    stats->_totalUsers = [[responseDictionary objectForKey:@"total_users"] retain];
    stats->_questionsPerMinute = [[responseDictionary objectForKey:@"questions_per_minute"] retain];
    stats->_answersPerMinute = [[responseDictionary objectForKey:@"answers_per_minute"] retain];
    stats->_badgesPerMinute = [[responseDictionary objectForKey:@"badges_per_minute"] retain];
    stats->_viewsPerDay = [[responseDictionary objectForKey:@"views_per_day"] retain];
    
    return stats;
}

@end
