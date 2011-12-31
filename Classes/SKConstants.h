//
//  SKConstants.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct SKQueryParametersStruct {
    NSString *pageSize;
    NSString *page;
    NSString *site;
} SKQueryParameters;

extern const struct SKAPIKeysStruct {
    NSString *backOff;
    NSString *errorID;
    NSString *errorMessage;
    NSString *errorName;
    NSString *hasMore;
    NSString *items;
    NSString *page;
    NSString *pageSize;
    NSString *quotaMax;
    NSString *quotaRemaining;
    NSString *total;
    NSString *type;
    struct {
        NSString *siteType;
        NSString *name;
        NSString *logoURL;
        NSString *apiSiteParameter;
        NSString *siteURL;
        NSString *audience;
        NSString *iconURL;
        NSString *aliases;
        NSString *siteState;
        NSString *styling;
        struct {
            NSString *linkColor;
            NSString *tagForegroundColor;
            NSString *tagBackgroundColor;
        } stylingKeys;
        NSString *launchDate;
        NSString *faviconURL;
        NSString *relatedSites;
        struct {
            NSString *name;
            NSString *siteURL;
            NSString *relation;
        } relatedSiteKeys;
        NSString *markdownExtensions;
    } site;
    
    struct {
        NSString *aboutMe;
        NSString *accountId;
        NSString *age;
        NSString *answerCount;
        NSString *badgeCounts;
        NSString *creationDate;
        NSString *displayName;
        NSString *downVoteCount;
        NSString *isEmployee;
        NSString *lastAccessDate;
        NSString *lastModifiedDate;
        NSString *link;
        NSString *location;
        NSString *profileImage;
        NSString *questionCount;
        NSString *reputation;
        NSString *reputationChangeDay;
        NSString *reputationChangeMonth;
        NSString *reputationChangeQuarter;
        NSString *reputationChangeWeek;
        NSString *reputationChangeYear;
        NSString *timedPenaltyDate;
        NSString *upVoteCount;
        NSString *userID;
        NSString *userType;
        NSString *viewCount;
        NSString *websiteURL;
    } user;
} SKAPIKeys;