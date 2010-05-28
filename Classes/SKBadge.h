//
//  SKBadge.h
//  StackKit
//
//  Created by Alex Rozanski on 26/01/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com
//

#import <Cocoa/Cocoa.h>
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
extern NSString * SKBadgeAwardedToUser;

@interface SKBadge : SKObject {
	NSNumber *badgeID;
	
	NSString *name;
	NSString *description;
	
	SKBadgeRank_t rank;
	
	BOOL tagBased;
	NSInteger numberAwarded;
}

@property (readonly) NSNumber *badgeID;
@property (readonly) NSString *name;
@property (readonly) NSString *description;
@property (readonly) SKBadgeRank_t rank;

@property (readonly) NSInteger numberAwarded;
@property (readonly, getter=isTagBased) BOOL tagBased;

@end
