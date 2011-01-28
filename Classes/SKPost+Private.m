//
//  SKPost+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKPost+Private.h"
#import "SKPost+Public.h"

@implementation SKPost (Private)

@dynamic body;
@dynamic creationDate;
@dynamic score;
@dynamic postID;
@dynamic owner;
@dynamic postActivity;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"ownerID", SKPostOwner,
			@"creationDate", SKPostCreationDate,
			nil];
}

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {
	[self setCreationDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:SKPostCreationDate] doubleValue]]];
		
//		NSDictionary * ownerDictionary = [dictionary objectForKey:SKPostOwner];
//		ownerID = [[ownerDictionary objectForKey:SKUserID] retain];
		
	[self setBody:[dictionary objectForKey:SKPostBody]];
	[self setScore:[dictionary objectForKey:SKPostScore]];
}

@end
