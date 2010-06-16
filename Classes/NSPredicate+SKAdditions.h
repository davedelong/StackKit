//
//  NSPredicate+SKAdditions.h
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

#import <Foundation/Foundation.h>
#import "SKDefinitions.h"

enum {
	SKAnyPredicateOperator = NSUIntegerMax
};

@interface NSPredicate (SKAdditions)

- (NSPredicate *) subPredicateForLeftExpression:(NSExpression *)left;
- (NSArray *) subPredicatesWithLeftExpression:(NSExpression *)left;
- (NSArray *) subPredicatesWithLeftKeyPath:(NSString *)left;

- (id) constantValueForLeftExpression:(NSExpression *)left;
- (id) constantValueForLeftKeyPath:(NSString *)left;

- (id) constantValueForOperator:(NSPredicateOperatorType)operator;
- (id) constantValueForOneOfOperators:(NSArray *)operators;

- (NSPredicate *) predicateByRemovingSubPredicateWithLeftExpression:(NSExpression *)left;
- (NSPredicate *) predicateByReplacingLeftKeyPathsFromMapping:(NSDictionary *)mapping;

- (BOOL) isComparisonPredicateWithLeftKeyPaths:(NSArray *)leftKeyPaths operator:(NSPredicateOperatorType)operator rightExpressionType:(NSExpressionType)rightType;
- (BOOL) isPredicateWithConstantValueEqualToLeftKeyPath:(NSString *)leftKeyPath;
- (BOOL) isSimpleAndPredicate;

- (SKRange) rangeOfConstantValuesForLeftKeyPath:(NSString *)left;

@end
