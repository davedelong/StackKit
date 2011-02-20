//
//  NSPredicate+SKAdditions.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
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

#import "NSPredicate+SKAdditions.h"
#import "SKFunctions.h"

enum {
	SKAnyPredicateOperator = NSUIntegerMax
};

@implementation NSPredicate (SKAdditions)

- (BOOL) isComparisonPredicateWithLeftKeyPaths:(NSArray *)leftKeyPaths operator:(NSPredicateOperatorType)operator rightExpressionType:(NSExpressionType)rightType {
	if ([self isKindOfClass:[NSComparisonPredicate class]] == NO) { return NO; }
	NSComparisonPredicate * comp = (NSComparisonPredicate *)self;
	
	NSExpression * left = [comp leftExpression];
	if ([left expressionType] != NSKeyPathExpressionType) { return NO; }
	
	NSString * leftKeyPath = [left keyPath];
	if ([leftKeyPaths containsObject:leftKeyPath] == NO) { return NO; }
	
	//pass SKAnyPredicateOperator to ignore operator
	if (operator != SKAnyPredicateOperator) {
		if ([comp predicateOperatorType] != operator) { return NO; }
	}
	
	NSExpression * right = [comp rightExpression];
	if ([right expressionType] != rightType) { return NO; }
	
	return YES;
}

- (NSArray *) sk_subPredicatesWithLeftExpression:(NSExpression *)left {
	if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
		NSArray * subPredicates = [compound subpredicates];
		
		NSMutableArray * matches = [NSMutableArray array];
		for (NSPredicate * subPredicate in subPredicates) {
			NSArray * subPredicateMatches = [subPredicate sk_subPredicatesWithLeftExpression:left];
			[matches addObjectsFromArray:subPredicateMatches];
		}
		return matches;
	} else if ([self isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate * comparison = (NSComparisonPredicate *)self;
		NSExpression * leftExpression = [comparison leftExpression];
		if ([leftExpression isEqual:left]) {
			return [NSArray arrayWithObject:self];
		}
	}
	return nil;
}

- (NSArray *) subPredicatesWithLeftKeyPath:(NSString *)left {
	return [self sk_subPredicatesWithLeftExpression:[NSExpression expressionForKeyPath:left]];
}

- (NSPredicate *) sk_subPredicateForLeftExpression:(NSExpression *)left {
	NSArray * matches = [self sk_subPredicatesWithLeftExpression:left];
	if ([matches count] > 0) {
		return [matches objectAtIndex:0];
	}
	return nil;
}

- (id) constantValueForLeftExpression:(NSExpression *)left {
	NSComparisonPredicate * comparison = (NSComparisonPredicate *)[self sk_subPredicateForLeftExpression:left];
	if (comparison == nil) { return nil; }
	if ([[comparison rightExpression] expressionType] != NSConstantValueExpressionType) { return nil; }
	
	return [[comparison rightExpression] constantValue];
}

- (id) sk_constantValueForLeftKeyPath:(NSString *)left {
	return [self constantValueForLeftExpression:[NSExpression expressionForKeyPath:left]];
}

- (id) constantValueForOperator:(NSPredicateOperatorType)operator {
	if ([self isKindOfClass:[NSComparisonPredicate class]] == NO) { return nil; }
	NSComparisonPredicate * comparison = (NSComparisonPredicate *)self;
	if ([comparison predicateOperatorType] != operator) { return nil; }
	NSExpression * rightExpression = [comparison rightExpression];
	if ([rightExpression expressionType] != NSConstantValueExpressionType) { return nil; }
	return [rightExpression constantValue];
}

- (id) constantValueForOneOfOperators:(NSArray *)operators {
	for (NSNumber * op in operators) {
		NSPredicateOperatorType operator = [op unsignedIntegerValue];
		id value = [self constantValueForOperator:operator];
		if (value) { return value; }
	}
	return nil;
}

- (BOOL) sk_isSimpleAndPredicate {
	if ([self isKindOfClass:[NSCompoundPredicate class]] == NO) { return NO; }
	NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
	if ([compound compoundPredicateType] != NSAndPredicateType) { return NO; }
	
	NSArray * subpredicates = [compound subpredicates];
	BOOL ok = YES;
	for (NSPredicate * subpredicate in subpredicates) {
		ok &= [subpredicate isKindOfClass:[NSComparisonPredicate class]];
	}
	
	return ok;
}

- (SKRange) sk_rangeOfConstantValuesForLeftKeyPath:(NSString *)left {
	SKRange result = SKRangeNotFound;
	if ([self isComparisonPredicateWithLeftKeyPaths:[NSArray arrayWithObject:left] 
										   operator:SKAnyPredicateOperator
								rightExpressionType:NSConstantValueExpressionType]) {
		NSComparisonPredicate * comparison = (NSComparisonPredicate *)self;
		
		id upperValue = [comparison constantValueForOneOfOperators:[NSArray arrayWithObjects:
																	[NSNumber numberWithUnsignedInteger:NSLessThanPredicateOperatorType],
																	[NSNumber numberWithUnsignedInteger:NSLessThanOrEqualToPredicateOperatorType],
																	nil]];
		if (upperValue) {
			result.upper = upperValue;
		}
		
		id lowerValue = [comparison constantValueForOneOfOperators:[NSArray arrayWithObjects:
																	[NSNumber numberWithUnsignedInteger:NSGreaterThanPredicateOperatorType],
																	[NSNumber numberWithUnsignedInteger:NSGreaterThanOrEqualToPredicateOperatorType],
																	nil]];
		if (lowerValue) {
			result.lower = lowerValue;
		}
	} else if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
		NSArray * subpredicates = [compound subPredicatesWithLeftKeyPath:left];
		for (NSPredicate * predicate in subpredicates) {
			SKRange subpredicateRange = [predicate sk_rangeOfConstantValuesForLeftKeyPath:left];
			if (result.lower == SKNotFound && subpredicateRange.lower != SKNotFound) {
				result.lower = subpredicateRange.lower;
			}
			if (result.upper == SKNotFound && subpredicateRange.upper != SKNotFound) {
				result.upper = subpredicateRange.upper;
			}
			if (result.lower != SKNotFound && result.upper != SKNotFound) { break; }
		}
	}
	return result;
}

- (NSSet *) sk_leftKeyPaths {
	NSMutableSet * paths = [NSMutableSet set];
	if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
		for (NSPredicate * subpredicate in [compound subpredicates]) {
			[paths unionSet:[subpredicate sk_leftKeyPaths]];
		}
	} else {
		NSComparisonPredicate * comparison = (NSComparisonPredicate *)self;
		if ([[comparison leftExpression] expressionType] == NSKeyPathExpressionType) {
			[paths addObject:[[comparison leftExpression] keyPath]];
		}
	}
	return paths;
}

//this has to return an NSNumber.  If it returned a BOOL, then we'd get an EXC_BAD_ACCESS when using it in our FUNCTION() predicate
- (NSNumber *) sk_matchesRecognizedKeyPathsAndOperators:(NSDictionary *)keyPaths {
	BOOL matches = YES;
	for (NSString * keyPath in keyPaths) {
		NSArray * allowedOperatorsForKeyPath = [keyPaths objectForKey:keyPath];
		NSArray * subPredicatesUsingKeyPath = [self subPredicatesWithLeftKeyPath:keyPath];
		for (NSComparisonPredicate * subPredicate in subPredicatesUsingKeyPath) {
			NSPredicateOperatorType operator = [subPredicate predicateOperatorType];
			NSNumber * boxed = [NSNumber numberWithUnsignedInteger:operator];
			if ([allowedOperatorsForKeyPath containsObject:boxed] == NO) {
				matches = NO;
				break;
			}
		}
		if (matches == NO) { break; }
	}
	return [NSNumber numberWithBool:matches];
}

@end
