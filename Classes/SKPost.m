//
//  SKPost.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "StackKit_Internal.h"

NSString * const SKPostCreationDate = @"creation_date";
NSString * const SKPostOwner = @"owner";
NSString * const SKPostBody = @"body";

@implementation SKPost

@synthesize creationDate, ownerID, body;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"ownerID", SKPostOwner,
			@"creationDate", SKPostCreationDate,
			nil];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite dictionaryRepresentation:dictionary]) {
		creationDate = [[dictionary objectForKey:SKPostCreationDate] retain];
		
		NSDictionary * ownerDictionary = [dictionary objectForKey:SKPostOwner];
		ownerID = [[ownerDictionary objectForKey:SKUserID] retain];
		
		body = [[dictionary objectForKey:SKPostBody] retain];
	}
	return self;
}

- (void) dealloc {
	[creationDate release];
	[ownerID release];
	[body release];
	[super dealloc];
}

- (SKUser *)owner {
	return [[self site] userWithID:[self ownerID]];
}

@end
