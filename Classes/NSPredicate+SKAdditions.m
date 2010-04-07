//
//  NSPredicate+SKAdditions.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "NSPredicate+SKAdditions.h"


@implementation NSPredicate (SKAdditions)

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

- (NSPredicate *) subPredicateForLeftExpression:(NSExpression *)left {
	NSArray * matches = [self subPredicatesWithLeftExpression:left];
	if ([matches count] > 0) {
		return [matches objectAtIndex:0];
	}
	return nil;
}

- (id) constantValueForLeftExpression:(NSExpression *)left {
	NSComparisonPredicate * comparison = (NSComparisonPredicate *)[self subPredicateForLeftExpression:left];
	if (comparison == nil) { return nil; }
	if ([[comparison rightExpression] expressionType] != NSConstantValueExpressionType) { return nil; }
	
	return [[comparison rightExpression] constantValue];
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

@end
