//
//  SKBadge.m
//  StackKit
//
//  Created by Alex Rozanski on 26/01/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com
//

#import "StackKit_Internal.h"

@interface SKBadge ()

- (id)initWithSite:(SKSite*)aSite badgeID:(NSString*)theID;

@end

@implementation SKBadge

@synthesize name, description;
@synthesize badgeID;
@synthesize badgeType;
@synthesize badgeLevel;
@synthesize numberOfBadgesAwarded;

+ (id)badgeWithSite:(SKSite*)aSite badgeID:(NSString*)theID
{
	//Check if the badge has already been cached
	id cachedBadge = [[aSite cachedBadges] objectForKey:theID];
	if (cachedBadge != nil) {
		return cachedBadge;
	}
	
	//If not create a new tag
	id newBadge = [[[self class] alloc] initWithSite:aSite badgeID:theID];
	[aSite cacheBadge:newBadge];
	
	return [newBadge autorelease];
}

//Private initializer
- (id)initWithSite:(SKSite*)aSite badgeID:(NSString*)theID
{
	if(self = [super initWithSite:aSite]) {
		badgeID = [theID copy];
	}
	
	return self;
}

- (void)dealloc
{
	[name release];
	[description release];
	[badgeID release];
	
	[super dealloc];
}

@end
