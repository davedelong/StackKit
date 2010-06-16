//
//  SKUserCommentsEndpoint.m
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

@implementation SKUserCommentsEndpoint

- (BOOL) validatePredicate:(NSPredicate *)predicate {
	if ([predicate isPredicateWithConstantValueEqualToLeftKeyPath:SKCommentOwner]) {
		id owner = [predicate constantValueForLeftKeyPath:SKCommentOwner];
		if (owner) {
			[self setPath:[NSString stringWithFormat:@"/users/%@/comments", SKExtractUserID(owner)]];
			return YES;
		}
	}
	
	if ([predicate isSimpleAndPredicate]) {
		//retrieve the user out of the AND predicate:
		NSArray * userIDPredicates = [predicate subPredicatesWithLeftKeyPath:SKCommentOwner];
		if ([userIDPredicates count] != 1) { goto errorExit; }
		NSPredicate * ownerPredicate = [userIDPredicates objectAtIndex:0];
		id owner = [ownerPredicate constantValueForLeftKeyPath:SKCommentOwner];
		if (!owner) { goto errorExit; }
		[self setPath:[NSString stringWithFormat:@"/users/%@/comments", SKExtractUserID(owner)]];
		
		//retrieve the creationDate range out of the predicate
		SKRange creationDateRange = [predicate rangeOfConstantValuesForLeftKeyPath:SKCommentCreationDate];
		if (creationDateRange.lower != SKNotFound) {
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:creationDateRange.lower] forKey:SKQueryFromDate];
		}
		if (creationDateRange.upper != SKNotFound) {
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:creationDateRange.upper] forKey:SKQueryToDate];
		}
		
		//retrieve the score range out of the predicate, but only if the sortKey is SKSortVotes
		NSArray * votePredicates = [predicate subPredicatesWithLeftKeyPath:SKCommentScore];
		if ([[self sortDescriptorKey] isEqual:SKSortVotes] == NO && [votePredicates count] > 0) { goto errorExit; }
		if ([votePredicates count] > 2) { goto errorExit; }
		
		SKRange voteRange = [predicate rangeOfConstantValuesForLeftKeyPath:SKCommentScore];
		if (voteRange.lower != SKNotFound) {
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:voteRange.lower] forKey:SKQueryMinSort];
		}
		if (voteRange.upper != SKNotFound) {
			[[self query] setObject:[NSNumber numberWithUnsignedInteger:voteRange.upper] forKey:SKQueryMaxSort];
		}
		
		return YES;
	}
	
errorExit:
	[self setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
	return NO;
}

@end
