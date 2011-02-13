//
//  SKFetchOperation.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKOperation.h"
#import "SKDefinitions.h"

@class SKFetchRequest;

@interface SKFetchOperation : SKOperation {
    SKFetchRequest *request;
    SKRequestHandler handler;
    SKActionBlock priorHandler;
    SKActionBlock afterHandler;
    NSError *error;
}

@property (nonatomic, copy) SKRequestHandler handler;
@property (nonatomic, copy) SKActionBlock priorHandler;
@property (nonatomic, copy) SKActionBlock afterHandler;
@property (nonatomic, retain) NSError *error;

- (id) initWithSite:(SKSite *)baseSite fetchRequest:(SKFetchRequest *)aRequest;

@end
