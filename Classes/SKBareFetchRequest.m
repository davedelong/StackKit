//
//  SKBareFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKBareFetchRequest.h"
#import <StackKit/SKFetchRequest_Internal.h>
#import <StackKit/SKFunctions.h>

@implementation SKBareFetchRequest

@synthesize url=_url;

- (NSString *)_path {
    return [_url path];
}

- (NSMutableDictionary *)_queryDictionary {
    return [NSMutableDictionary dictionaryWithDictionary:SKDictionaryFromQueryString([_url query])];
}

@end
