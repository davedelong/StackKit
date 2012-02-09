//
//  SKTagFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

@interface SKTagFetchRequest()

@property (nonatomic, copy) NSDate *minDate;
@property (nonatomic, copy) NSDate *maxDate;
@property (nonatomic, copy) NSString *nameContains;
@property (nonatomic, retain) NSMutableIndexSet *userIDs;

@end
