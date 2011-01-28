//
//  SKPost.h
//  StackKit
//
//  Created by Dave DeLong on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@class SKUser;
@class SKUserActivity;

@interface SKPost :  SKObject  
{
}

@property (nonatomic, retain, readonly) NSString * body;
@property (nonatomic, retain, readonly) NSDate * creationDate;
@property (nonatomic, retain, readonly) NSNumber * score;
@property (nonatomic, retain, readonly) NSNumber * postID;
@property (nonatomic, retain, readonly) SKUser * owner;
@property (nonatomic, retain, readonly) NSSet* postActivity;

@end

