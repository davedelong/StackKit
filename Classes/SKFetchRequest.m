//
//  SKFetchRequest.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKFetchRequest.h"
#import "SKFetchRequest+Private.h"
#import "SKObject+Private.h"
#import "SKConstants.h"
#import "SKRequestBuilder.h"
#import "SKSite+Private.h"
#import "SKJSONParser.h"
#import "SKFetchOperation.h"

@implementation SKFetchRequest
@synthesize entity;
@synthesize sortDescriptor;
@synthesize fetchLimit;
@synthesize fetchOffset;
@synthesize fetchTotal;
@synthesize predicate;
@synthesize error;
@synthesize fetchURL;

+ (Class) operationClass {
    return [SKFetchOperation class];
}

- (id) init {
	self = [super init];
	if (self) {
		fetchLimit = SKPageSizeLimitMax;
		fetchOffset = 0;
	}
	return self;
}

- (void) dealloc {
    [site release];
	[sortDescriptor release];
	[predicate release];
	[error release];
	[fetchURL release];
	[super dealloc];
}

- (void) setSite:(SKSite *)aSite {
    if (site != aSite) {
        [site release];
        site = [aSite retain];
    }
}

- (SKSite *) site {
    return site;
}

- (void) setFetchLimit:(NSUInteger)newLimit {
	if (newLimit > SKPageSizeLimitMax) {
		newLimit = SKPageSizeLimitMax;
	}
	fetchLimit = newLimit;
}

@end
