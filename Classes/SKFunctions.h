//
//  SKFunctions.h
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
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

#ifdef StackKitMobile
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "SKDefinitions.h"

@class SKFetchRequest;

void SKQLog(NSString *format, ...);

id SKInvalidPredicateErrorForFetchRequest(SKFetchRequest * request, NSDictionary * userInfo);

BOOL SKIsVectorClass(id value);
NSString * SKExtractVector(id value, SKExtractor extractor);
NSString * SKVectorizedCollection(id value);

id SKExtractPostID(id value);
id SKExtractCommentID(id value);
id SKExtractQuestionID(id value);
id SKExtractAnswerID(id value);
id SKExtractUserID(id value);
id SKExtractBadgeID(id value);
id SKExtractTagName(id value);

NSDate * SKExtractDate(id value);
NSUInteger SKExtractInteger(id value);

#ifdef StackKitMobile
UIColor * SKColorFromHexString(NSString * hexString);
#else
NSColor * SKColorFromHexString(NSString * hexString);
#endif
