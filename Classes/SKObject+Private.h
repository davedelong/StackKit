//
//  SKObject+Private.h
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
#import "SKObject.h"

@class SKSite;
@class SKFetchRequest;

@interface SKObject (Private)

@property (nonatomic, retain) SKSite * site;

+ (id) objectMergedWithDictionary:(NSDictionary *)dictionary inSite:(SKSite *)site;
- (void) mergeInformationFromDictionary:(NSDictionary *)dictionary;

#pragma mark Class methods implemented by SKObject
// used in valueForKey:
+ (NSString *) propertyKeyFromAPIAttributeKey:(NSString *)key;

#pragma mark Class methods that should be overriden by subclasses
// used to help valueForKey: out so that we can request properties via the constants (SKQuestionID vs @"questionID", for example)
+ (NSDictionary *) APIAttributeToPropertyMapping;
// keys used to extract information from the JSON response
+ (NSString *) dataKey;
+ (NSString *) uniqueIDKey;

@end
