//
//  SKObject.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/SKTypes.h>

@class SKSite;

@interface SKObject : NSObject

@property (nonatomic, readonly) SKSite *site;

- (void)requestFullObjectWithCompletionHandler:(SKErrorHandler)handler;

@end
