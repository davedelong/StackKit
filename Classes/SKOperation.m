//
//  SKOperation.m
//  StackKit
//
//  Created by Dave DeLong on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKOperation.h"


@implementation SKOperation
@synthesize site;

- (id) initWithSite:(SKSite *)baseSite {
    self = [super init];
    if (self) {
        [self setSite:baseSite];
    }
}

- (void) dealloc {
    [site release];
    [super dealloc];
}

@end
