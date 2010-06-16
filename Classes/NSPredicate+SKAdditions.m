//
//  NSPredicate+SKAdditions.m
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

#import "NSPredicate+SKAdditions.h"
#import "SKFunctions.h"

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

- (BOOL) isPredicateWithConstantValueEqualToLeftKeyPath:(NSString *)leftKeyPath {
	return [self isComparisonPredicateWithLeftKeyPaths:[NSArray arrayWithObject:leftKeyPath] 
											  operator:NSEqualToPredicateOperatorType 
								   rightExpressionType:NSConstantValueExpressionType];
}

- (NSArray *) subPredicatesWithLeftExpression:(NSExpression *)left {
	if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
		NSArray * subPredicates = [compound subpredicates];
		
		NSMutableArray * matches = [NSMutableArray array];
		for (NSPredicate * subPredicate in subPredicates) {
			NSArray * subPredicateMatches = [subPredicate subPredicatesWithLeftExpression:left];
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
	return [self subPredicatesWithLeftExpression:[NSExpression expressionForKeyPath:left]];
}

- (NSPredicate *) subPredicateForLeftExpression:(NSExpression *)left {
	NSArray * matches = [self subPredicatesWithLeftExpression:left];
	if ([matches count] > 0) {
		return [matches objectAtIndex:0];
	}
	return nil;
}

- (NSPredicate *) subPredicateForLeftKeyPath:(NSString *)left {
	return [self subPredicateForLeftExpression:[NSExpression expressionForKeyPath:left]];
}

- (id) constantValueForLeftExpression:(NSExpression *)left {
	NSComparisonPredicate * comparison = (NSComparisonPredicate *)[self subPredicateForLeftExpression:left];
	if (comparison == nil) { return nil; }
	if ([[comparison rightExpression] expressionType] != NSConstantValueExpressionType) { return nil; }
	
	return [[comparison rightExpression] constantValue];
}

- (id) constantValueForLeftKeyPath:(NSString *)left {
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

- (NSPredicate *) predicateByRemovingSubPredicateWithLeftExpression:(NSExpression *)left {
	if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
		NSMutableArray * newSubpredicates = [NSMutableArray array];
		NSArray * currentSubpredicates = [compound subpredicates];
		
		for (NSPredicate * subPredicate in currentSubpredicates) {
			NSPredicate * newVersion = [subPredicate predicateByRemovingSubPredicateWithLeftExpression:left];
			if (newVersion != nil) {
				[newSubpredicates addObject:newVersion];
			}
		}
		
		if ([newSubpredicates count] > 0) {
			NSCompoundPredicate * newCompound = [[NSCompoundPredicate alloc] initWithType:[compound compoundPredicateType] subpredicates:newSubpredicates];
			return [newCompound autorelease];
		} else {
			return nil;
		}
	} else if ([self isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate * comparison = (NSComparisonPredicate *)self;
		NSExpression * leftExpression = [comparison leftExpression];
		if ([leftExpression isEqual:left]) {
			return nil;
		}
		return comparison;
	}
	return nil;
}

- (NSPredicate *) predicateByReplacingLeftKeyPathsFromMapping:(NSDictionary *)mapping {
	if ([self isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate * compP = (NSComparisonPredicate *)self;
		NSExpression * left = [compP leftExpression];
		if ([left expressionType] == NSKeyPathExpressionType) {
			NSString * keyPath = [left keyPath];
			NSString * mappedKeyPath = [mapping objectForKey:keyPath];
			if (mappedKeyPath != nil) {
				NSComparisonPredicate * translated = [[NSComparisonPredicate alloc] initWithLeftExpression:[NSExpression expressionForKeyPath:mappedKeyPath] 
																						   rightExpression:[compP rightExpression] 
																								  modifier:[compP comparisonPredicateModifier] 
																									  type:[compP predicateOperatorType] 
																								   options:[compP options]];
				return [translated autorelease];
			}
		}
	} else if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compoundP = (NSCompoundPredicate *)self;
		NSArray * subpredicates = [compoundP subpredicates];
		NSMutableArray * translated = [NSMutableArray array];
		for (NSPredicate * subpredicate in subpredicates) {
			NSPredicate * newSubpredicate = [subpredicate predicateByReplacingLeftKeyPathsFromMapping:mapping];
			if (newSubpredicate != nil) {
				[translated addObject:newSubpredicate];
			}
		}
		if ([translated count] == 0) { return nil; }
		NSCompoundPredicate * newCompound = [[NSCompoundPredicate alloc] initWithType:[compoundP compoundPredicateType] 
																		subpredicates:translated];
		return [newCompound autorelease];
	} else {
		return nil;
	}
	return self;
}

- (BOOL) isSimpleAndPredicate {
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

- (SKRange) rangeOfConstantValuesForLeftKeyPath:(NSString *)left {
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
			result.upper = SKExtractInteger(upperValue);
		}
		
		id lowerValue = [comparison constantValueForOneOfOperators:[NSArray arrayWithObjects:
																	[NSNumber numberWithUnsignedInteger:NSGreaterThanPredicateOperatorType],
																	[NSNumber numberWithUnsignedInteger:NSGreaterThanOrEqualToPredicateOperatorType],
																	nil]];
		if (lowerValue) {
			result.lower = SKExtractInteger(lowerValue);
		}
	} else if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
		NSArray * subpredicates = [compound subPredicatesWithLeftKeyPath:left];
		for (NSPredicate * predicate in subpredicates) {
			SKRange subpredicateRange = [predicate rangeOfConstantValuesForLeftKeyPath:left];
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

@end
