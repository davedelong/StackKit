//
//  SKFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@interface SKFetchRequest : SKObject {
	Class entity;
	NSArray * sortDescriptors;
	NSNumber * fetchLimit;
	NSNumber * fetchOffset;
	NSPredicate * predicate;
}

@property Class entity;
@property (retain) NSArray * sortDescriptors;
@property (retain) NSNumber * fetchLimit;
@property (retain) NSNumber * fetchOffset;
@property (retain) NSPredicate * predicate;

@end
