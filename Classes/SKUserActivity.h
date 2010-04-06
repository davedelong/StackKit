//
//  SKUserActivity.h
//  StackKit
//
//  Created by Dave DeLong on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"
#import "SKPost.h"

typedef enum {
	SKUserActivityTypeComment = 0,
	SKUserActivityTypeRevision = 1,
	SKUserActivityTypeBadge = 2,
	SKUserActivityTypeAskOrAnswered = 3,
	SKUserActivityTypeAccepted = 4
} SKUserActivityType_t;

typedef enum {
	SKUserActivityActionTypeComment = 0,
	SKUserActivityActionTypeRevised = 1,
	SKUserActivityActionTypeAwarded = 2,
	SKUserActivityActionTypeAnswered = 3
} SKUserActivityActionType_t;

extern NSString * SKUserActivityType;
extern NSString * SKUserActivityPostID;
extern NSString * SKUserActivityPostType;
extern NSString * SKUserActivityCommentID;
extern NSString * SKUserActivityAction;
extern NSString * SKUserActivityCreationDate;
extern NSString * SKUserActivityDescription;
extern NSString * SKUserActivityDetail;

@interface SKUserActivity : SKObject {
	SKUserActivityType_t type;
	
	NSNumber * postID;
	SKPostType_t postType;
	
	NSNumber * commentID;
	
	SKUserActivityActionType_t action;
	
	NSDate * creationDate;
	
	NSString * activityDescription;
	NSString * activityDetail;
}

@property (readonly) SKUserActivityType_t type;
@property (readonly) NSNumber * postID;
@property (readonly) SKPostType_t postType;
@property (readonly) NSNumber * commentID;
@property (readonly) SKUserActivityActionType_t action;
@property (readonly) NSDate * creationDate;
@property (readonly) NSString * activityDescription;
@property (readonly) NSString * activityDetail;

@end
