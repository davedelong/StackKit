//
//  SKConstants_Internal.h
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKFunctions.h"

extern NSString * const SKFrameworkAPIKey;

#pragma mark -
#pragma mark Statistics Keys
extern NSString * const SKStatsTotalQuestions;
extern NSString * const SKStatsTotalUnansweredQuestions;
extern NSString * const SKStatsTotalAcceptedAnswers;
extern NSString * const SKStatsTotalAnswers;
extern NSString * const SKStatsTotalComments;
extern NSString * const SKStatsTotalVotes;
extern NSString * const SKStatsTotalBadges;
extern NSString * const SKStatsTotalUsers;
extern NSString * const SKStatsQuestionsPerMinute;
extern NSString * const SKStatsAnswersPerMinute;
extern NSString * const SKStatsBadgesPerMinute;
extern NSString * const SKStatsViewsPerDay;

extern NSString * const SKStatsAPIInfo;
extern NSString * const SKStatsAPIInfoVersion;
extern NSString * const SKStatsAPIInfoRevision;

extern NSString * const SKStateSiteInfo;
extern NSString * const SKStatsSiteInfoName;
extern NSString * const SKStatsSiteInfoLogoURL;
extern NSString * const SKStatsSiteInfoAPIURL;
extern NSString * const SKStatsSiteInfoSiteURL;
extern NSString * const SKStatsSiteInfoDescription;
extern NSString * const SKStatsSiteInfoIconURL;

#pragma mark -

extern NSString * const SKSortCreation;
extern NSString * const SKSortActivity;
extern NSString * const SKSortVotes;
extern NSString * const SKSortViews;
extern NSString * const SKSortNewest;
extern NSString * const SKSortFeatured;
extern NSString * const SKSortHot;
extern NSString * const SKSortWeek;
extern NSString * const SKSortMonth;
extern NSString * const SKSortAdded;
extern NSString * const SKSortPopular;
extern NSString * const SKSortReputation;
extern NSString * const SKSortName;

extern NSString * const SKQueryTrue;
extern NSString * const SKQueryFalse;

extern NSUInteger const SKPageSizeLimitMax;
extern NSString * const SKQueryPage;
extern NSString * const SKQueryPageSize;
extern NSString * const SKQuerySort;
extern NSString * const SKQuerySortOrder;
extern NSString * const SKQueryFromDate;
extern NSString * const SKQueryToDate;
extern NSString * const SKQueryMinSort;
extern NSString * const SKQueryMaxSort;
extern NSString * const SKQueryFilter;
extern NSString * const SKQueryBody;
extern NSString * const SKQueryTagged;
extern NSString * const SKQueryNotTagged;
extern NSString * const SKQueryInTitle;
extern NSString * const SKQueryAnswers;
extern NSString * const SKQueryComments;

extern NSString * const SKAPIAbout_Me;
extern NSString * const SKAPIAccept_Rate;
extern NSString * const SKAPIAccepted;
extern NSString * const SKAPIAccepted_Answer_ID;
extern NSString * const SKAPIAge;
extern NSString * const SKAPIAnswers;
extern NSString * const SKAPIAnswer_Count;
extern NSString * const SKAPIAnswer_ID;
extern NSString * const SKAPIAssociation_ID;
extern NSString * const SKAPIAward_Count;
extern NSString * const SKAPIAwards;
extern NSString * const SKAPIBadge_ID;
extern NSString * const SKAPIBody;
extern NSString * const SKAPIBounty_Amount;
extern NSString * const SKAPIBounty_Closes_Date;
extern NSString * const SKAPIBronze;
extern NSString * const SKAPIClosed_Date;
extern NSString * const SKAPIClosed_Reason;
extern NSString * const SKAPIComments;
extern NSString * const SKAPIComment_ID;
extern NSString * const SKAPICommunity_Owned;
extern NSString * const SKAPICount;
extern NSString * const SKAPICreation_Date;
extern NSString * const SKAPIDescription;
extern NSString * const SKAPIDisplay_Name;
extern NSString * const SKAPIDown_Vote_Count;
extern NSString * const SKAPIEdit_Count;
extern NSString * const SKAPIEmail_Hash;
extern NSString * const SKAPIFavorite_Count;
extern NSString * const SKAPIGold;
extern NSString * const SKAPILast_Access_Date;
extern NSString * const SKAPILast_Activity_Date;
extern NSString * const SKAPILast_Edit_Date;
extern NSString * const SKAPILocation;
extern NSString * const SKAPILocked_Date;
extern NSString * const SKAPIName;
extern NSString * const SKAPIOwner;
extern NSString * const SKAPIPost_ID;
extern NSString * const SKAPIPost_Type;
extern NSString * const SKAPIQuestion_Count;
extern NSString * const SKAPIQuestion_ID;
extern NSString * const SKAPIRank;
extern NSString * const SKAPIReply_To_User;
extern NSString * const SKAPIReputation;
extern NSString * const SKAPIScore;
extern NSString * const SKAPISilver;
extern NSString * const SKAPISummary;
extern NSString * const SKAPITags;
extern NSString * const SKAPITag_Based;
extern NSString * const SKAPITitle;
extern NSString * const SKAPIUp_Vote_Count;
extern NSString * const SKAPIUser;
extern NSString * const SKAPIUser_Badges;
extern NSString * const SKAPIUser_ID;
extern NSString * const SKAPIUser_Type;
extern NSString * const SKAPIView_Count;
extern NSString * const SKAPIWebsite_URL;

// placeholder
extern NSString * const SKAPIFavorited_Date;
