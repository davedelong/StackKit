//
//  SKRequestBuilder.h
//  StackKit
//
//  Created by Dave DeLong on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackKit_Internal.h"

@interface SKRequestBuilder : NSObject {
	
}

+ (NSURL *) URLForFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error;

@end
