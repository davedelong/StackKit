//
//  SKSiteStats.m
//  StackKit
//
//  Created by Alex Rozanski on 12/02/2011.
//  Copyright 2011 Alex Rozanski. All rights reserved.
//

#import "SKSiteStatistics.h"
#import "SKConstants_Internal.h"

@implementation SKSiteStatistics

@synthesize site = _site;
@synthesize totalQuestions = _totalQuestions, totalUnansweredQuestions = _totalUnansweredQuestions, totalAcceptedAnswers = _totalAcceptedAnswers;
@synthesize totalAnswers = _totalAnswers, totalComments = _totalComments, totalVotes = _totalVotes, totalBadges = _totalBadges, totalUsers = _totalUsers;
@synthesize questionsPerMinute = _questionsPerMinute, answersPerMinute = _answersPerMinute, badgesPerMinute = _badgesPerMinute;
@synthesize viewsPerDay = _viewsPerDay;
@synthesize apiVersion=_apiVersion, apiRevision=_apiRevision;

#pragma mark - 
#pragma mark Init/Dealloc

- (id)initWithSite:(SKSite *)site responseDictionary:(NSDictionary *)responseDictionary
{
    self = [super init];
    if (self) {
        _site = [site retain];
        _totalQuestions = [[responseDictionary objectForKey:SKStatsTotalQuestions] retain];
        _totalUnansweredQuestions = [[responseDictionary objectForKey:SKStatsTotalUnansweredQuestions] retain];
        _totalAcceptedAnswers = [[responseDictionary objectForKey:SKStatsTotalAcceptedAnswers] retain];
        _totalAnswers = [[responseDictionary objectForKey:SKStatsTotalAnswers] retain];
        _totalComments = [[responseDictionary objectForKey:SKStatsTotalComments] retain];
        _totalVotes = [[responseDictionary objectForKey:SKStatsTotalVotes] retain];
        _totalBadges = [[responseDictionary objectForKey:SKStatsTotalBadges] retain];
        _totalUsers = [[responseDictionary objectForKey:SKStatsTotalUsers] retain];
        _questionsPerMinute = [[responseDictionary objectForKey:SKStatsQuestionsPerMinute] retain];
        _answersPerMinute = [[responseDictionary objectForKey:SKStatsAnswersPerMinute] retain];
        _badgesPerMinute = [[responseDictionary objectForKey:SKStatsBadgesPerMinute] retain];
        _viewsPerDay = [[responseDictionary objectForKey:SKStatsViewsPerDay] retain];
        
        NSDictionary *apiInfo = [responseDictionary objectForKey:SKStatsAPIInfo];
        _apiVersion = [[apiInfo objectForKey:SKStatsAPIInfoVersion] retain];
        _apiRevision = [[apiInfo objectForKey:SKStatsAPIInfoRevision] retain];
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
    [_apiVersion release];
    [_apiRevision release];
    
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
