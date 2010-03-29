//
//  NSPredicate+SKAdditions.m
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "NSPredicate+SKAdditions.h"


@implementation NSPredicate (SKAdditions)

- (id) constantValueForLeftExpression:(NSExpression *)left {
	if ([self isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate * compound = (NSCompoundPredicate *)self;
		NSArray * subPredicates = [compound subpredicates];
		for (NSPredicate * subPredicate in subPredicates) {
			id value = [subPredicate constantValueForLeftExpression:left];
			if (value != nil) {
				return value;
			}
		}
	} else if ([self isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate * comparison = (NSComparisonPredicate *)self;
		NSExpression * leftExpression = [comparison leftExpression];
		if ([leftExpression isEqual:left] && [[comparison rightExpression] expressionType] == NSConstantValueExpressionType) {
			return [[comparison rightExpression] constantValue];
		}
	}
	return nil;
}

@end
