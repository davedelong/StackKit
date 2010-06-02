//
//  SKPost.m
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

#import "StackKit_Internal.h"

NSString * const SKPostCreationDate = __SKPostCreationDate;
NSString * const SKPostOwner = __SKPostOwner;
NSString * const SKPostBody = __SKPostBody;
NSString * const SKPostScore = __SKPostScore;

@implementation SKPost

@synthesize creationDate, ownerID, body, score;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"ownerID", SKPostOwner,
			@"creationDate", SKPostCreationDate,
			nil];
}

+ (NSDictionary *) validPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKPostOwner, @"ownerID",
			nil];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite dictionaryRepresentation:dictionary]) {
		creationDate = [[dictionary objectForKey:SKPostCreationDate] retain];
		
		NSDictionary * ownerDictionary = [dictionary objectForKey:SKPostOwner];
		ownerID = [[ownerDictionary objectForKey:SKUserID] retain];
		
		body = [[dictionary objectForKey:SKPostBody] retain];
		score = [[dictionary objectForKey:SKPostScore] retain];
	}
	return self;
}

- (void) dealloc {
	[creationDate release];
	[ownerID release];
	[body release];
	[score release];
	[super dealloc];
}

- (SKUser *)owner {
	return [[self site] userWithID:[self ownerID]];
}

@end
