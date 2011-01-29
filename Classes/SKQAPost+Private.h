//
//  SKQAPost+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKQAPost.h"

@interface SKQAPost (Private)

@property (nonatomic, retain) NSNumber * upVotes;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * lastActivityDate;
@property (nonatomic, retain) NSDate * lastEditDate;
@property (nonatomic, retain) NSNumber * downVotes;
@property (nonatomic, retain) NSDate * lockedDate;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) NSNumber * communityOwned;
@property (nonatomic, retain) NSSet* comments;

@end


@interface SKQAPost (CoreDataGeneratedAccessors)
- (void)addCommentsObject:(SKComment *)value;
- (void)removeCommentsObject:(SKComment *)value;
- (void)addComments:(NSSet *)value;
- (void)removeComments:(NSSet *)value;

@end
