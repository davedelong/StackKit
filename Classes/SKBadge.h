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
} SKBadgeRank;

extern NSString * SKBadgeID;
extern NSString * SKBadgeColor;
extern NSString * SKBadgeName;
extern NSString * SKBadgeDescription;
extern NSString * SKBadgeAwardCount;
extern NSString * SKBadgeTagBased;

@interface SKBadge : SKObject {
	NSNumber *ID;
	
	NSString *name;
	NSString *description;
	
	SKBadgeRank rank;
	
	BOOL tagBased;
	NSInteger numberAwarded;
}

@property (readonly) NSNumber *ID;
@property (readonly) NSString *name;
@property (readonly) NSString *description;
@property (readonly) SKBadgeRank rank;

@property (readonly) NSInteger numberAwarded;
@property (readonly, getter=isTagBased) BOOL tagBased;

@end
