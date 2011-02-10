//
//  SKDefinitions.h
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

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#define SKColor UIColor

#else

#define SKColor NSColor

#endif

#ifdef NS_BLOCKS_AVAILABLE
typedef void(^SKFetchRequestCompletionHandler)(NSArray *,NSError *);

typedef void(^SKStatisticsHandler)(NSDictionary *);
#endif

typedef id (*SKExtractor)(id);

typedef struct _SKRange {
	id lower;
	id upper;
} SKRange;

#define SKNotFound nil

extern SKRange const SKRangeNotFound;

#pragma mark -
#pragma mark Enums

typedef enum {
	SKSiteStateNormal = 0,
	SKSiteStateLinkedMeta = 1,
	SKSiteStateOpenBeta = 2,
	SKSiteStateClosedBeta = 3
} SKSiteState;

typedef enum {
	SKUserTypeAnonymous = 0,
	SKUserTypeUnregistered = 1,
	SKUserTypeRegistered = 2,
	SKUserTypeModerator = 3
} SKUserType_t;

//Enumeration for badge "levels" – bronze, silver or gold
typedef enum {
	SKBadgeRankBronze = 0,
	SKBadgeRankSilver = 1,
	SKBadgeRankGold = 2
} SKBadgeRank_t;

typedef enum {
	SKPostTypeQuestion = 0,
	SKPostTypeAnswer = 1
} SKPostType_t;

#pragma mark -
#pragma mark Helpher Macros

#ifndef SK_BOX
#define SK_BOX(o,...) _sk_boxOperators(o, ##__VA_ARGS__, NSNotFound)
#endif

#ifndef SK_EREASON
#define SK_EREASON(o,...) [NSDictionary dictionaryWithObject:[NSString stringWithFormat:(o), ##__VA_ARGS__] forKey:NSLocalizedDescriptionKey]
#endif

#ifndef SK_SORTERROR
#define SK_SORTERROR(o,...) [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:SK_EREASON(o, ##__VA_ARGS__)]
#endif

#ifndef SK_PREDERROR
#define SK_PREDERROR(o,...) [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:SK_EREASON(o, ##__VA_ARGS__)]
#endif

#ifndef SK_ENTERROR
#define SK_ENTERROR(o,...) [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:SK_EREASON(o, ##__VA_ARGS__)]
#endif

#ifndef SK_GETTER
#define SK_GETTER(t,n) -(t) n { return [self valueForKey:@"n"]; }
#endif