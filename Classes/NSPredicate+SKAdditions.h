//
//  NSPredicate+SKAdditions.h
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSPredicate (SKAdditions)

- (NSArray *) subPredicatesWithLeftExpression:(NSExpression *)left;
- (NSPredicate *) subPredicateForLeftExpression:(NSExpression *)left;
- (id) constantValueForLeftExpression:(NSExpression *)left;
- (NSPredicate *) predicateByRemovingSubPredicateWithLeftExpression:(NSExpression *)left;

- (BOOL) isComparisonPredicateWithLeftKeyPaths:(NSArray *)leftKeyPaths operator:(NSPredicateOperatorType)operator rightExpressionType:(NSExpressionType)rightType;

@end
