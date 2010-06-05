//
//  SKCallback.h
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

#import <Foundation/Foundation.h>
#import "SKDefinitions.h"

@class SKFetchRequest;

@interface SKCallback : NSObject {
#ifdef NS_BLOCKS_AVAILABLE
	SKFetchRequestCompletionHandler completionHandler;
#endif
	
	id _target;
	
	SEL _successSelector;
	SEL _failureSelector;
}

@property (readonly) SEL successSelector;
@property (readonly) SEL failureSelector;

+ (id)callbackWithTarget:(id)target successSelector:(SEL)onSuccess failureSelector:(SEL)onFailure;
- (id)initWithTarget:(id)target successSelector:(SEL)onSuccess failureSelector:(SEL)onFailure;

#ifdef NS_BLOCKS_AVAILABLE
+ (id) callbackWithCompletionHandler:(SKFetchRequestCompletionHandler)handler;
- (id) initWithCompletionHandler:(SKFetchRequestCompletionHandler)handler;
#endif

- (void) fetchRequest:(SKFetchRequest *)fetchRequest failedWithError:(NSError *)argument;
- (void) fetchRequest:(SKFetchRequest *)fetchRequest succeededWithResults:(NSArray *)argument;

@end
