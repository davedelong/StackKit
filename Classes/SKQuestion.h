//
//  SKQuestion.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKQAPost.h"


@interface SKQuestion : SKQAPost {
	NSSet * tags;
	NSString * title;
	
	NSUInteger favoritedCount;
	NSUInteger viewCount;
}

@property (readonly) NSSet * tags;
@property (readonly) NSUInteger favoritedCount;
@property (readonly) NSUInteger viewCount;
@property (readonly) NSString * title;

@end
