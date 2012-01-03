//
//  SKTag.h
//  StackKit
//
//  Created by Dave DeLong on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKObject.h>

@interface SKTag : SKObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly, getter=isRequired) BOOL required;
@property (nonatomic, readonly, getter=isModeratorOnly) BOOL moderatorOnly;

@end
