//
//  SKQuestion.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPost.h"


@interface SKQuestion : SKPost {
	NSSet * tags;
}

@property (readonly) NSSet * tags;

@end
