//
//  SKComment+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKComment.h"

@interface SKComment (Private)

@property (nonatomic, retain) NSNumber * editCount;
@property (nonatomic, retain) SKQAPost * post;
@property (nonatomic, retain) SKUser * directedToUser;

@end
