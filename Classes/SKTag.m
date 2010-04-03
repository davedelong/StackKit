//
//  SKTag.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

@interface SKTag ()

- (id) initWithSite:(SKSite *)aSite name:(NSString *)aName;

@end

@implementation SKTag

@synthesize name;
@synthesize numberOfTaggedQuestions;

#pragma mark -
#pragma mark Init/Dealloc

//Convenience initializer
+ (id)tagWithSite:(SKSite*)aSite name:(NSString*)aName {
	//Check if the tag has already been cached
	id cachedTag = [[aSite cachedTags] objectForKey:aName];
	if (cachedTag != nil) {
		return cachedTag;
	}
	
	//If not create a new tag
	id newTag = [[[self class] alloc] initWithSite:aSite name:aName];
	[aSite cacheTag:newTag];
	
	return [newTag autorelease];
}

//Private initializer
- (id) initWithSite:(SKSite *)aSite name:(NSString *)aName {	
	if (self = [super initWithSite:aSite]) {
		name = [aName copy];
	}
	
	return self;
}

- (void) dealloc {
	[name release];
	
	[super dealloc];
}

@end
