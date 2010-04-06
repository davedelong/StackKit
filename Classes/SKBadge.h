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
	SKBadgeColorBronze = 0,
	SKBadgeColorSilver = 1,
	SKBadgeColorGold = 2
} SKBadgeColor_t;

extern NSString * SKBadgeID;
extern NSString * SKBadgeColor;
extern NSString * SKBadgeName;
extern NSString * SKBadgeDescription;
extern NSString * SKBadgeAwardCount;
extern NSString * SKBadgeTagBased;

@interface SKBadge : SKObject {
	NSNumber * badgeID;
	
	NSString * badgeName;
	NSString * badgeDescription;
	
	SKBadgeColor_t badgeColor;
	
	BOOL tagBased;
	NSInteger numberOfBadgesAwarded;
}

@property (readonly) NSNumber *badgeID;
@property (readonly) NSString *badgeName;
@property (readonly) NSString *badgeDescription;
@property (readonly) SKBadgeColor_t badgeColor;

@property (readonly) NSInteger numberOfBadgesAwarded;
@property (readonly, getter=isTagBased) BOOL tagBased;

@end
