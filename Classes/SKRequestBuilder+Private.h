//
//  SKRequestBuilder+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKRequestBuilder.h"

@interface SKRequestBuilder ()

+ (Class) recognizedFetchEntity;
+ (NSSet *) recognizedPredicateKeyPaths;

@end
