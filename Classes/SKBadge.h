//
//  SKBadge.h
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
#import "SKObject.h"

//Enumeration for badge "levels" – bronze, silver or gold
typedef enum {
	SKBadgeRankBronze = 0,
	SKBadgeRankSilver = 1,
	SKBadgeRankGold = 2
} SKBadgeRank_t;

extern NSString * SKBadgeID;
extern NSString * SKBadgeRank;
extern NSString * SKBadgeName;
extern NSString * SKBadgeDescription;
extern NSString * SKBadgeAwardCount;
extern NSString * SKBadgeTagBased;
extern NSString * SKBadgesAwardedToUser;

@interface SKBadge : SKObject {
	NSNumber *badgeID;
	
	NSString *name;
	NSString *description;
	
	SKBadgeRank_t rank;
	
	BOOL tagBased;
	NSNumber * numberAwarded;
}

@property (readonly) NSNumber *badgeID;
@property (readonly) NSString *name;
@property (readonly) NSString *description;
@property (readonly) SKBadgeRank_t rank;

@property (readonly) NSNumber * numberAwarded;
@property (readonly, getter=isTagBased) BOOL tagBased;

@end
