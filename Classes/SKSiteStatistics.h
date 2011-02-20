/** Site Statistics
 
 A simple object for containing the statistics of an site on the SE network.  This is retrieved via -[SKSite statistics] or -[SKSite requestStatisticsWithCompletionHandler:]
 */

#import <Foundation/Foundation.h>

#import "SKSite.h"


@interface SKSiteStatistics : NSObject {
    SKSite *_site;
    
    NSNumber *_totalQuestions;
    NSNumber *_totalUnansweredQuestions;
    NSNumber *_totalAcceptedAnswers;
    
    NSNumber *_totalAnswers;
    NSNumber *_totalComments;
    NSNumber *_totalVotes;
    NSNumber *_totalBadges;
    NSNumber *_totalUsers;
    
    NSNumber *_questionsPerMinute;
    NSNumber *_answersPerMinute;
    NSNumber *_badgesPerMinute;
    
    NSNumber *_viewsPerDay;
    
    NSString *_apiVersion;
    NSString *_apiRevision;
}

@property (readonly) SKSite *site;
@property (readonly) NSNumber *totalQuestions;
@property (readonly) NSNumber *totalUnansweredQuestions;
@property (readonly) NSNumber *totalAcceptedAnswers;
@property (readonly) NSNumber *totalAnswers;
@property (readonly) NSNumber *totalComments;
@property (readonly) NSNumber *totalVotes;
@property (readonly) NSNumber *totalBadges;
@property (readonly) NSNumber *totalUsers;
@property (readonly) NSNumber *questionsPerMinute;
@property (readonly) NSNumber *answersPerMinute;
@property (readonly) NSNumber *badgesPerMinute;
@property (readonly) NSNumber *viewsPerDay;
@property (readonly) NSString *apiVersion;
@property (readonly) NSString *apiRevision;

@end
