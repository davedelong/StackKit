//
//  SKComment.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKPost.h"

@class SKQAPost;
@class SKUser;

@interface SKComment :  SKPost  
{
}

@property (nonatomic, readonly) NSNumber * editCount;
@property (nonatomic, readonly) SKQAPost * post;
@property (nonatomic, readonly) SKUser * directedToUser;

@end



