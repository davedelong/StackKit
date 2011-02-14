//
//  SKConstants_Internal.m
//  StackKit
//
//  Created by Dave DeLong on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKConstants_Internal.h"

NSString * const SKFrameworkAPIKey = @"hqh1uqA-AkeM48lxWWPeWA";

#pragma mark -
#pragma mark Statistics Keys
NSString * const SKStatsTotalQuestions = @"total_questions";
NSString * const SKStatsTotalUnansweredQuestions = @"total_unanswered";
NSString * const SKStatsTotalAcceptedAnswers = @"total_accepted";
NSString * const SKStatsTotalAnswers = @"total_answers";
NSString * const SKStatsTotalComments = @"total_comments";
NSString * const SKStatsTotalVotes = @"total_votes";
NSString * const SKStatsTotalBadges = @"total_badges";
NSString * const SKStatsTotalUsers = @"total_users";
NSString * const SKStatsQuestionsPerMinute = @"questions_per_minute";
NSString * const SKStatsAnswersPerMinute = @"answers_per_minute";
NSString * const SKStatsBadgesPerMinute = @"badges_per_minute";
NSString * const SKStatsViewsPerDay = @"views_per_day";

NSString * const SKStatsAPIInfo = @"api_version";
NSString * const SKStatsAPIInfoVersion = @"version";
NSString * const SKStatsAPIInfoRevision = @"revision";	

NSString * const SKStateSiteInfo = @"site";
NSString * const SKStatsSiteInfoName = @"name";
NSString * const SKStatsSiteInfoLogoURL = @"logo_url";
NSString * const SKStatsSiteInfoAPIURL = @"api_endpoint";
NSString * const SKStatsSiteInfoSiteURL = @"site_url";
NSString * const SKStatsSiteInfoDescription = @"description";
NSString * const SKStatsSiteInfoIconURL = @"icon_url";

NSString * const SKAPIAbout_Me = @"about_me";
NSString * const SKAPIAccept_Rate = @"accept_rate";
NSString * const SKAPIAccepted = @"accepted";
NSString * const SKAPIAccepted_Answer_ID = @"accepted_answer_id";
NSString * const SKAPIAge = @"age";
NSString * const SKAPIAnswers = @"answers";
NSString * const SKAPIAnswer_Count = @"answer_count";
NSString * const SKAPIAnswer_ID = @"answer_id";
NSString * const SKAPIAssociation_ID = @"association_id";
NSString * const SKAPIAward_Count = @"award_count";
NSString * const SKAPIAwards = @"awards";
NSString * const SKAPIBadge_ID = @"badge_id";
NSString * const SKAPIBody = @"body";
NSString * const SKAPIBounty_Amount = @"bounty_amount";
NSString * const SKAPIBounty_Closes_Date = @"bounty_closes_date";
NSString * const SKAPIBronze = @"bronze";
NSString * const SKAPIClosed_Date = @"closed_date";
NSString * const SKAPIClosed_Reason = @"closed_reason";
NSString * const SKAPIComments = @"comments";
NSString * const SKAPIComment_ID = @"comment_id";
NSString * const SKAPICommunity_Owned = @"community_owned";
NSString * const SKAPICount = @"count";
NSString * const SKAPICreation_Date = @"creation_date";
NSString * const SKAPIDescription = @"description";
NSString * const SKAPIDisplay_Name = @"display_name";
NSString * const SKAPIDown_Vote_Count = @"down_vote_count";
NSString * const SKAPIEdit_Count = @"edit_count";
NSString * const SKAPIEmail_Hash = @"email_hash";
NSString * const SKAPIFavorite_Count = @"favorite_count";
NSString * const SKAPIGold = @"gold";
NSString * const SKAPILast_Access_Date = @"last_access_date";
NSString * const SKAPILast_Activity_Date = @"last_activity_date";
NSString * const SKAPILast_Edit_Date = @"last_edit_date";
NSString * const SKAPILocation = @"location";
NSString * const SKAPILocked_Date = @"locked_date";
NSString * const SKAPIName = @"name";
NSString * const SKAPIOwner = @"owner";
NSString * const SKAPIPost_ID = @"post_id";
NSString * const SKAPIPost_Type = @"post_type";
NSString * const SKAPIQuestion_Count = @"question_count";
NSString * const SKAPIQuestion_ID = @"question_id";
NSString * const SKAPIRank = @"rank";
NSString * const SKAPIReply_To_User = @"reply_to_user";
NSString * const SKAPIReputation = @"reputation";
NSString * const SKAPIScore = @"score";
NSString * const SKAPISilver = @"silver";
NSString * const SKAPISummary = @"summary";
NSString * const SKAPITags = @"tags";
NSString * const SKAPITag_Based = @"tag_based";
NSString * const SKAPITitle = @"title";
NSString * const SKAPIUp_Vote_Count = @"up_vote_count";
NSString * const SKAPIUser = @"user";
NSString * const SKAPIUser_Badges = @"user_badges";
NSString * const SKAPIUser_ID = @"user_id";
NSString * const SKAPIUser_Type = @"user_type";
NSString * const SKAPIView_Count = @"view_count";
NSString * const SKAPIWebsite_URL = @"website_url";

// placeholder
NSString * const SKAPIFavorited_Date;

#pragma mark -
#pragma mark Sorting Keys


NSString * const SKSortCreation = @"creation";
NSString * const SKSortActivity = @"activity";
NSString * const SKSortVotes = @"votes";
NSString * const SKSortViews = @"views";
NSString * const SKSortNewest = @"newest";
NSString * const SKSortFeatured = @"featured";
NSString * const SKSortHot = @"hot";
NSString * const SKSortWeek = @"week";
NSString * const SKSortMonth = @"month";
NSString * const SKSortAdded = @"added";
NSString * const SKSortPopular = @"popular";
NSString * const SKSortReputation = @"reputation";
NSString * const SKSortName = @"name";

#pragma mark Query Keys

NSString * const SKQueryTrue = @"true";
NSString * const SKQueryFalse = @"false";

NSString * const SKQueryFromDate = @"fromdate";
NSString * const SKQueryToDate = @"todate";
NSString * const SKQueryMinSort = @"min";
NSString * const SKQueryMaxSort = @"max";
NSString * const SKQueryPage = @"page";
NSString * const SKQueryPageSize = @"pagesize";
NSString * const SKQuerySort = @"sort";
NSString * const SKQuerySortOrder = @"order";
NSString * const SKQueryFilter = @"filter";
NSString * const SKQueryBody = @"body";
NSString * const SKQueryTagged = @"tagged";
NSString * const SKQueryNotTagged = @"nottagged";
NSString * const SKQueryInTitle = @"intitle";
NSString * const SKQueryAnswers = @"answers";
NSString * const SKQueryComments = @"comments";
