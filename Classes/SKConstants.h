/** Public constants
 
 This file contains all of the publicly available constants.
 */

#import <Foundation/Foundation.h>

extern NSString * const SKAPIVersion;

extern NSUInteger const SKPageSizeLimitMax;

#pragma mark -
#pragma mark Placeholders
extern NSString * const SKTagsParticipatedInByUser;

#pragma mark -
#pragma mark Error Constants
extern NSString * const SKErrorDomain;
extern NSString * const SKExceptionInvalidHandler;
extern NSString * const SKExceptionInvalidRequest;

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
