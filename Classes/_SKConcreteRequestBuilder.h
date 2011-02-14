//
//  _SKConcreteRequestBuilder.h
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

#import <Foundation/Foundation.h>
#import "SKFetchRequest.h"
#import "SKFetchRequest+Private.h"
#import "SKDefinitions.h"
#import "SKFunctions.h"
#import "SKConstants.h"
#import "NSPredicate+SKAdditions.h"
#import "SKConstants_Internal.h"
#import "SKMacros.h"

@interface _SKConcreteRequestBuilder : NSObject {
	@private
	SKFetchRequest * fetchRequest;
	NSError * error;
	NSURL * URL;
	NSMutableDictionary * query;
	NSString * path;
}

@property (nonatomic, readonly) SKFetchRequest * fetchRequest;
@property (nonatomic, retain) NSError * error;
@property (nonatomic, readonly, retain) NSURL * URL;
@property (nonatomic, readonly) NSMutableDictionary * query;
@property (nonatomic, copy) NSString * path;

+ (Class) recognizedFetchEntity;
+ (BOOL) recognizesAPredicate;
+ (NSDictionary *) recognizedPredicateKeyPaths;
+ (NSSet *) requiredPredicateKeyPaths;
+ (BOOL) recognizesASortDescriptor;
+ (NSDictionary *) recognizedSortDescriptorKeys;

- (id) initWithFetchRequest:(SKFetchRequest *)request;

@end

@interface _SKConcreteRequestBuilder (SubclassMethods)

- (void) buildURL;
- (NSPredicate *) requestPredicate;
- (NSSortDescriptor *) requestSortDescriptor;

@end