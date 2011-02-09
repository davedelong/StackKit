//
//  SKStatisticsOperation.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDefinitions.h"
#import "SKOperation.h"

@interface SKStatisticsOperation : SKOperation {
    SKStatisticsHandler handler;
}

@property (nonatomic, copy) SKStatisticsHandler handler;

- (id) initWithSite:(SKSite *)baseSite completionHandler:(SKStatisticsHandler)aHandler;

@end
