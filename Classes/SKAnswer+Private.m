//
//  SKAnswer+Private.m
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKAnswer+Private.h"
#import "SKAnswer+Public.h"
#import "SKObject+Private.h"

@implementation SKAnswer (Private)

@dynamic accepted;
@dynamic question;

+ (NSString *) dataKey {
	return @"answers";
}

+ (NSString *) uniqueIDKey {
	return SKAnswerID;
}

- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary {
	[super mergeInformationFromDictionary:dictionary];
	[self setAccepted:[dictionary objectForKey:SKAnswerIsAccepted]];
	
	//TODO: set question
//		questionID = [[dictionary objectForKey:SKAnswerQuestion] retain];
}

@end
