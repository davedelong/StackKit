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

@property (nonatomic, retain, readonly) NSNumber * editCount;
@property (nonatomic, retain, readonly) SKQAPost * post;
@property (nonatomic, retain, readonly) SKUser * directedToUser;

@end



