//
//  SKAssociatedUserOperation.h
//  StackKit
//
//  Created by Dave DeLong on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKOperation.h"

@class SKUser;

@interface SKAssociatedUserOperation : SKOperation {
    SKUser *baseUser;
    SKRequestHandler handler;
}

@property (nonatomic, copy) SKRequestHandler handler;

- (id) initWithUser:(SKUser *)user handler:(SKRequestHandler)completionHandler;

@end
