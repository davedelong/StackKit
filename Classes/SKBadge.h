//
//  SKBadge.h
//  StackKit
//
//  Created by Alex Rozanski on 26/01/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com
//

#import <Cocoa/Cocoa.h>
#import "SKObject.h"

//Enumeration for general badges or tag-based badges
typedef enum {
	SKBadgeTypeGeneral,
	SKBadgeTypeTag
} SKBadgeType;


@interface SKBadge : SKObject {
	NSString *name;
	NSString *description;
	NSInteger badgeType;
	
	NSInteger badgeCount;
}

@property (readonly) NSString *name;
@property (readonly) NSString *description;
@property (readonly) NSInteger badgeType;

@property (readonly) NSInteger badgeCount;

@end
