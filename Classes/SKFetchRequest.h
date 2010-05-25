//
//  SKFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 3/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"
#import "SKFetchRequestDelegate.h"

@interface SKFetchRequest : SKObject {
	Class entity;
	NSArray * sortDescriptors;
	NSUInteger fetchLimit;
	NSUInteger fetchOffset;
	NSPredicate * predicate;
	
	NSError * error;
	id<SKFetchRequestDelegate> delegate;
}

@property Class entity;
@property (retain) NSArray * sortDescriptors;
@property NSUInteger fetchLimit;
@property NSUInteger fetchOffset;
@property (retain) NSPredicate * predicate;
@property (retain) NSError * error;
@property (assign) id<SKFetchRequestDelegate> delegate;

@end
