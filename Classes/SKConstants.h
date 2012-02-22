//
//  SKConstants.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct SKQueryKeysStruct {
    NSString *pageSize;
    NSString *page;
    NSString *site;
    NSString *min;
    NSString *max;
    NSString *fromDate;
    NSString *toDate;
    NSString *sort;
    NSString *order;
    NSString *accessToken;
    struct {
        NSString *ascending;
        NSString *descending;
    } sortOrder;
    NSString *filter;
    struct {
        NSString *nameContains;
    } user;
    struct {
        NSString *nameContains;
    } tag;
    struct {
        NSString *nameContains;
    } badge;
} SKQueryKeys;

extern const struct SKSortValuesStruct {
    struct {
        NSString *creationDate;
        NSString *name;
        NSString *reputation;
        NSString *lastModifiedDate;
    } user;
    struct {
        NSString *popularity;
        NSString *lastUsedDate;
        NSString *name;
    } tag;
    struct {
        NSString *rank;
        NSString *name;
        NSString *type;
    } badge;
    struct {
        NSString *score;
        NSString *lastActivityDate;
        NSString *creationDate;
    } question;
    struct {
        NSString *score;
        NSString *lastActivityDate;
        NSString *creationDate;
    } answer;
    struct {
        NSString *score;
        NSString *creationDate;
    } comment;
    
} SKSortValues;

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
    
    struct {
        NSString *name;
        NSString *count;
        NSString *isRequired;
        NSString *isModeratorOnly;
    } tag;
    
    struct {
        NSString *badgeID;
        NSString *rank;
        NSString *name;
        NSString *description;
        NSString *awardCount;
        NSString *badgeType;
        NSString *user;
        NSString *link;
    } badge;
    
    struct {
        NSString *questionID;
        NSString *answerID;
        NSString *lockedDate;
        NSString *creationDate;
        NSString *lastEditDate;
        NSString *lastActivityDate;
        NSString *score;
        NSString *communityOwnedDate;
        NSString *isAccepted;
        NSString *body;
        NSString *owner;
        NSString *title;
        NSString *upVoteCount;
        NSString *downVoteCount;
    } answer;
    
    struct {
        NSString *commentID;
        NSString *postID;
        NSString *creationDate;
        NSString *postType;
        NSString *score;
        NSString *edited;
        NSString *body;
        NSString *owner;
        NSString *replyToUser;
    } comment;
    
    struct {
        NSString *questionID;
        NSString *lastEditDate;
        NSString *creationDate;
        NSString *lastActivityDate;
        NSString *lockedDate;
        NSString *score;
        NSString *communityOwnedDate;
        NSString *answerCount;
        NSString *acceptedAnswerID;
        NSString *bountyClosesDate;
        NSString *bountyAmount;
        NSString *closedDate;
        NSString *protectedDate;
        NSString *body;
        NSString *title;
        NSString *closedReason;
        NSString *upVoteCount;
        NSString *downVoteCount;
        NSString *favoriteCount;
        NSString *viewCount;
        NSString *owner;
        NSString *isAnswered;
    } question;
    
    struct {
        NSString *parentPostID;
        NSString *parentPostType;
    } childPost;
    
    struct {
        NSString *postID;
        NSString *postType;
        NSString *body;
        NSString *creationDate;
        NSString *ownerID;
        NSString *score;
    } post;
    
} SKAPIKeys;