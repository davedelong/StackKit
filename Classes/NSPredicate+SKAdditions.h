//
//  NSPredicate+SKAdditions.h
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSPredicate (SKAdditions)

- (id) constantValueForLeftExpression:(NSExpression *)left;

@end
