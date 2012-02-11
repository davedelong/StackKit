//
//  SKTag.h
//  StackKit
//
//  Created by Dave DeLong on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>

@interface SKTag : SKObject

@property (readonly) NSString *name;
@property (readonly) NSUInteger count;
@property (readonly, getter=isRequired) BOOL required;
@property (readonly, getter=isModeratorOnly) BOOL moderatorOnly;

@end
