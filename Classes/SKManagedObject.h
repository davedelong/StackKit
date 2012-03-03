//
//  SKManagedObject.h
//  StackKit
//
//  Created by Dave DeLong on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SKManagedObject : NSManagedObject

@property (nonatomic, readonly) NSString *uniqueIdentifier;

@end
