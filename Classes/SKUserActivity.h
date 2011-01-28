//
//  SKUserActivity.h
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import <Foundation/Foundation.h>
#import "SKObject.h"
#import "SKDefinitions.h"

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

extern NSString * const SKUserActivityType;
extern NSString * const SKUserActivityPostID;
extern NSString * const SKUserActivityPostType;
extern NSString * const SKUserActivityCommentID;
extern NSString * const SKUserActivityAction;
extern NSString * const SKUserActivityCreationDate;
extern NSString * const SKUserActivityDescription;
extern NSString * const SKUserActivityDetail;

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
