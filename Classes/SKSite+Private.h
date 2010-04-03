//
//  SKSite+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSite.h"
#import "SKUser.h"
#import "SKTag.h"
#import "SKPost.h"

@interface SKSite ()

- (void) cacheUser:(SKUser *)newUser;
- (void) cacheTag:(SKTag *)newTag;
- (void) cachePost:(SKPost *)newPost;
- (void) cacheBadge:(SKBadge *)newBadge;

@end
