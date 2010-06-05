//
//  SKCallback.m
//  StackKit
/**
 Copyright (c) 2010 Alex Rozanski
 
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

#import "SKCallback.h"


@implementation SKCallback

#pragma mark -
#pragma mark Init/Dealloc

- (id)initWithTarget:(id)target successSelector:(SEL)onSuccess failureSelector:(SEL)onFailure
{
	if(self = [super init]) {
		_target = target;
		_successSelector = onSuccess;
		_failureSelector = onFailure;
	}
	
	return self;
}

+ (id)callbackWithTarget:(id)target successSelector:(SEL)onSuccess failureSelector:(SEL)onFailure
{
	return [[[[self class] alloc] initWithTarget:target successSelector:onSuccess failureSelector:onFailure] autorelease];
}

#pragma mark -
#pragma mark Invoking

- (void)invokeOnSuccessWithArgument:(id)argument
{
	[_target performSelector:_successSelector withObject:argument];
}

- (void)invokeOnFailureWithArgument:(id)argument
{
	[_target performSelector:_failureSelector withObject:argument];
}

@end
