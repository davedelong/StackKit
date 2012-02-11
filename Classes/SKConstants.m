//
//  SKConstants.m
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKConstants.h"

const struct SKQueryKeysStruct SKQueryKeys = {
    .pageSize   = @"pagesize",
    .page       = @"page",
    .site       = @"site",
    .min        = @"min",
    .max        = @"max",
    .fromDate   = @"fromdate",
    .toDate     = @"todate",
    .sort       = @"sort",
    .sortOrder  = {
        .ascending = @"asc",
        .descending = @"desc"
    },
    .order      = @"order",
    .filter     = @"filter",
    .user       = {
        .nameContains = @"inname"
    },
    .tag        = {
        .nameContains = @"inname"
    },
    .badge      = {
        .nameContains = @"inname"
    }
};
const struct SKSortValuesStruct SKSortValues = {
    .user = {
        .creationDate = @"creation",
        .name = @"name",
        .reputation = @"reputation",
        .lastModifiedDate = @"modified"
    },
    .tag = {
        .popularity = @"popular",
        .lastUsedDate = @"activity",
        .name = @"name"
    },
    .badge = {
        .rank = @"rank",
        .name = @"name",
        .type = @"type"
    },
    .answer = {
        .score = @"votes",
        .lastActivityDate = @"activity",
        .creationDate = @"creation"
    },
    .comment = {
        .score = @"votes",
        .creationDate = @"creation"
    }
};

const struct SKAPIKeysStruct SKAPIKeys = {
    .backOff            = @"backoff",
    .errorID            = @"error_id",
    .errorMessage       = @"error_message",
    .errorName          = @"error_name",
    .hasMore            = @"has_more",
    .items              = @"items",
    .page               = @"page",
    .pageSize           = @"page_size",
    .quotaMax           = @"quota_max",
    .quotaRemaining     = @"quota_remaining",
    .total              = @"total",
    .type               = @"type",
    .site = {
        .siteType = @"site_type",
        .name = @"name",
        .logoURL = @"logo_url",
        .apiSiteParameter = @"api_site_parameter",
        .siteURL = @"site_url",
        .audience = @"audience",
        .iconURL = @"icon_url",
        .aliases = @"aliases",
        .siteState = @"site_state",
        .styling = @"styling",
        .stylingKeys = {
            .linkColor = @"link_color",
            .tagForegroundColor = @"tag_foreground_color",
            .tagBackgroundColor = @"tag_background_color"
        },
        .launchDate = @"launch_date",
        .faviconURL = @"faviconURL",
        .relatedSites = @"related_sites",
        .relatedSiteKeys = {
            .name = @"name",
            .siteURL = @"site_url",
            .relation = @"relation"
        },
        .markdownExtensions = @"markdown_extensions"
    },
    .user = {
        .aboutMe = @"about_me",
        .accountId = @"account_id",
        .age = @"age",
        .answerCount = @"answer_count",
        .badgeCounts = @"badge_counts",
        .creationDate = @"creation_date",
        .displayName = @"display_name",
        .downVoteCount = @"down_vote_count",
        .isEmployee = @"is_employee",
        .lastAccessDate = @"last_access_date",
        .lastModifiedDate = @"last_modified_date",
        .link = @"link",
        .location = @"location",
        .profileImage = @"profile_image",
        .questionCount = @"question_count",
        .reputation = @"reputation",
        .reputationChangeDay = @"reputation_change_day",
        .reputationChangeMonth = @"reputation_change_month",
        .reputationChangeQuarter = @"reputation_change_quarter",
        .reputationChangeWeek = @"reputation_change_week",
        .reputationChangeYear = @"reputation_change_year",
        .timedPenaltyDate = @"timed_penalty_date",
        .upVoteCount = @"up_vote_count",
        .userID = @"user_id",
        .userType = @"user_type",
        .viewCount = @"view_count",
        .websiteURL = @"website_url"
    },
    .tag = {
        .name = @"name",
        .count = @"count",
        .isRequired = @"is_required",
        .isModeratorOnly = @"is_moderator_only"
    },
    .badge = {
        .badgeID = @"badge_id",
        .rank = @"rank",
        .name = @"name",
        .description = @"description",
        .awardCount = @"awardCount",
        .badgeType = @"badge_type",
        .user = @"user",
        .link = @"link"
    },
    .answer = {
        .questionID = @"question_id",
        .answerID = @"answer_id",
        .lockedDate = @"locked_date",
        .creationDate = @"creation_date",
        .lastEditDate = @"last_edit_date",
        .lastActivityDate = @"last_activity_date",
        .score = @"score",
        .communityOwnedDate = @"community_owned_date",
        .isAccepted = @"is_accepted",
        .body = @"body",
        .owner = @"owner",
        .title = @"title",
        .upVoteCount = @"up_vote_count",
        .downVoteCount = @"down_vote_count"
    },
    .comment = {
        .commentID = @"comment_id",
        .postID = @"post_id",
        .creationDate = @"creation_date",
        .postType = @"post_type",
        .score = @"score",
        .edited = @"edited",
        .body = @"body",
        .owner = @"owner",
        .replyToUser = @"reply_to_user"
    },
    .question = {
        .questionID = @"question_id",
        .lastEditDate = @"last_edit_date",
        .creationDate = @"creation_date",
        .lastActivityDate = @"last_activity_date",
        .lockedDate = @"locked_date",
        .score = @"score",
        .communityOwnedDate = @"community_owned_date",
        .answerCount = @"answer_count",
        .acceptedAnswerID = @"accepted_answer_id",
        .bountyClosesDate = @"bounty_closes_date",
        .bountyAmount = @"bounty_amount",
        .closedDate = @"closed_date",
        .protectedDate = @"protected_date",
        .body = @"body",
        .title = @"title",
        .closedReason = @"closed_reason",
        .upVoteCount = @"up_vote_count",
        .downVoteCount = @"down_vote_count",
        .favoriteCount = @"favorite_count",
        .viewCount = @"view_count",
        .owner = @"owner",
        .isAnswered = @"is_answered"
    },
    .childPost = {
        .parentPostID = @"parent_id",
        .parentPostType = @"parent_type"
    },
    .post = {
        .postID = @"post_id",
        .postType = @"post_type",
        .ownerID = @"owner_id",
        .body = @"body",
        .creationDate = @"creation_date",
        .score = @"score"
    }
};
