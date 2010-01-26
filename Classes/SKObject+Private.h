//
//  SKObject+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@interface SKObject ()

- (void) loadJSON:(NSDictionary *)jsonDictionary;
- (id) jsonObjectAtURL:(NSURL *)aURL;

@end
