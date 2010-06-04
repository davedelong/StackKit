//
//  SKQuestionSearchEndpoint.m
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

@implementation SKQuestionSearchEndpoint

- (NSDictionary *) validSortDescriptorKeys {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKSortActivity, @"lastActivityDate",
			SKSortActivity, SKQuestionLastActivityDate,
			SKSortViews, @"viewCount",
			SKSortViews, SKQuestionViewCount,
			SKSortCreation, @"creationDate",
			SKSortCreation, SKQuestionCreationDate,
			SKSortVotes, @"score",
			SKSortVotes, SKQuestionScore,
			nil];
}

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	[self setPath:@"/search"];
	
	NSArray * leftPaths = [NSArray arrayWithObjects:SKQuestionTitle, SKQuestionTags, nil];
	if ([predicate isComparisonPredicateWithLeftKeyPaths:leftPaths operator:NSContainsPredicateOperatorType rightExpressionType:NSConstantValueExpressionType]) {
		//title CONTAINS %@
		//tags CONTAINS %@
		id title = [predicate constantValueForLeftKeyPath:SKQuestionTitle];
		id tags = [predicate constantValueForLeftKeyPath:SKQuestionTags];
		
		if (title) {
			[[self query] setObject:[title description] forKey:SKQuestionTitle];
			return YES;
		} else if (tags) {
			NSArray * names = SKExtractTagNames(tags);
			NSString * vector = [names componentsJoinedByString:@";"];
			[[self query] setObject:vector forKey:@"tagged"];
			return YES;
		}
	} else if ([predicate isKindOfClass:[NSCompoundPredicate class]]) {
		//NOT(tags CONTAINS %@)
		NSCompoundPredicate * compound = (NSCompoundPredicate *)predicate;
		if ([compound compoundPredicateType] == NSNotPredicateType && [[compound subpredicates] count] == 1) {
			id tags = [[[compound subpredicates] objectAtIndex:0] constantValueForLeftKeyPath:SKQuestionTags];
			if (tags) {
				NSArray * names = SKExtractTagNames(tags);
				NSString * vector = [names componentsJoinedByString:@";"];
				[[self query] setObject:vector forKey:@"nottagged"];
				return YES;
			}
		}
	}

	[self setPath:nil];
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
	return NO;
}

@end
