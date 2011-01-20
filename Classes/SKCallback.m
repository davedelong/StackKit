//
//  SKCallback.m
//  StackKit
/**
  Copyright (c) 2011 Alex Rozanski
 
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

#import "StackKit_Internal.h"

@implementation SKCallback
@synthesize successSelector=_successSelector;
@synthesize failureSelector=_failureSelector;

#pragma mark -
#pragma mark Init/Dealloc

#ifdef NS_BLOCKS_AVAILABLE
+ (id) callbackWithCompletionHandler:(SKFetchRequestCompletionHandler)handler {
	return [[[self alloc] initWithCompletionHandler:handler] autorelease];
}

- (id) initWithCompletionHandler:(SKFetchRequestCompletionHandler)handler {
	if (self = [super init]) {
		completionHandler = Block_copy(handler);
	}
	return self;
}
#endif

+ (id)callbackWithTarget:(id)target successSelector:(SEL)onSuccess failureSelector:(SEL)onFailure
{
	return [[[self alloc] initWithTarget:target successSelector:onSuccess failureSelector:onFailure] autorelease];
}

- (id)initWithTarget:(id)target successSelector:(SEL)onSuccess failureSelector:(SEL)onFailure
{
	if(self = [super init]) {
		_target = [target retain];
		_successSelector = onSuccess;
		_failureSelector = onFailure;
	}
	
	return self;
}

- (void) dealloc {
#ifdef NS_BLOCKS_AVAILABLE
	Block_release(completionHandler);
#endif
	[_target release];
	[super dealloc];
}

#pragma mark -
#pragma mark Invoking

- (void) finishWithInformation:(NSDictionary *)information {
	SKFetchRequest * request = [information objectForKey:@"request"];
	NSArray * results = [information objectForKey:@"results"];
	NSError * error = [information objectForKey:@"error"];

#if NS_BLOCKS_AVAILABLE
	if (completionHandler != NULL) {
		completionHandler(results, error);
		return;
	}
#endif
	
	if (_successSelector != NULL && results != nil) {
		[_target performSelector:_successSelector withObject:request withObject:results];
	} else if (_failureSelector != NULL && error != nil) {
		[_target performSelector:_failureSelector withObject:request withObject:error];
	}
}

- (void) fetchRequest:(SKFetchRequest *)fetchRequest succeededWithResults:(NSArray *)argument
{
	NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:
						   fetchRequest, @"request",
						   argument, @"results",
						   nil];
	
	if ([[NSThread currentThread] isEqual:[NSThread mainThread]]) {
		[self finishWithInformation:info];
	} else {
		[self performSelectorOnMainThread:@selector(finishWithInformation:) withObject:info waitUntilDone:NO];
	}
}

- (void) fetchRequest:(SKFetchRequest *)fetchRequest failedWithError:(NSError *)argument
{
	NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:
						   fetchRequest, @"request",
						   argument, @"error",
						   nil];
	
	if ([[NSThread currentThread] isEqual:[NSThread mainThread]]) {
		[self finishWithInformation:info];
	} else {
		[self performSelectorOnMainThread:@selector(finishWithInformation:) withObject:info waitUntilDone:NO];
	}
}

@end
