//
//  SKTag.m
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

NSString * const SKTagName = @"name";
NSString * const SKTagCount = @"count";
NSString * const SKTagsParticipatedInByUser = __SKUserID;

NSString * const SKTagNumberOfTaggedQuestions = @"tag_popular";
NSString * const SKTagLastUsedDate = @"tag_activity";

NSUInteger SKTagDefaultPageSize = 70;

@implementation SKTag

@synthesize name;
@synthesize numberOfTaggedQuestions;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKTagMappings = nil;
	if (_kSKTagMappings == nil) {
		_kSKTagMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
							 @"name", SKTagName,
							 @"numberOfTaggedQuestions", SKTagCount,
							 nil];
	}
	return _kSKTagMappings;
}

+ (NSString *) dataKey {
	return @"tags";
}

+ (NSArray *) endpoints {
	return [NSArray arrayWithObjects:
			[SKAllTagsEndpoint class],
			[SKUserTagsEndpoint class],
			[SKSearchTagsEndpoint class],
			nil];
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		name = [[dictionary objectForKey:SKTagName] retain];
		numberOfTaggedQuestions = [[dictionary objectForKey:SKTagCount] retain];
	}
	return self;
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) {
		return NO;
	}
	
	return ([[self name] isEqual:[object name]]&&[[self site] isEqual:[object site]]);
}

- (void) dealloc {
	[name release];
	[numberOfTaggedQuestions release];
	[super dealloc];
}

@end
