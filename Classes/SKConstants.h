//
//  SKConstants.h
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
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

#import <Foundation/Foundation.h>

extern NSString * const SKAPIKey;
extern NSString * const SKAPIVersion;

#pragma mark -
#pragma mark Statistics Keys
extern NSString * const SKStatsTotalQuestions;
extern NSString * const SKStatsTotalUnansweredQuestions;
extern NSString * const SKStatsTotalAnswers;
extern NSString * const SKStatsTotalComments;
extern NSString * const SKStatsTotalVotes;
extern NSString * const SKStatsTotalBadges;
extern NSString * const SKStatsTotalUsers;
extern NSString * const SKStatsQuestionsPerMinute;
extern NSString * const SKStatsAnswersPerMinutes;
extern NSString * const SKStatsBadgesPerMinute;

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
#pragma mark Error Constants
extern NSString * const SKErrorDomain;
extern NSString * const SKExceptionInvalidHandler;

#pragma mark Error codes
extern NSUInteger const SKErrorCodeNotImplemented;
extern NSUInteger const SKErrorCodeInvalidEntity;
extern NSUInteger const SKErrorCodeInvalidPredicate;
extern NSUInteger const SKErrorCodeUnknownError;

extern NSInteger const SKErrorCodeNotFound;
extern NSInteger const SKErrorCodeInternalServerError;
extern NSInteger const SKErrorCodeInvalidApplicationPublicKey;
extern NSInteger const SKErrorCodeInvalidPageSize;
extern NSInteger const SKErrorCodeInvalidSort;
extern NSInteger const SKErrorCodeInvalidOrder;
extern NSInteger const SKErrorCodeRequestRateExceeded;
extern NSInteger const SKErrorCodeInvalidVectorFormat;
extern NSInteger const SKErrorCodeTooManyIds;
extern NSInteger const SKErrorCodeUnconstrainedSearch;
extern NSInteger const SKErrorCodeInvalidTags;