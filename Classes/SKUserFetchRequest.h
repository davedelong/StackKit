//
//  SKUserFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>

@interface SKUserFetchRequest ()

@property (copy) NSDate *minDate;
@property (copy) NSDate *maxDate;
@property (copy) NSString *nameContains;
@property (readonly) NSMutableIndexSet *userIDs;

@end
