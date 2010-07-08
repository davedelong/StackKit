//
//  SKSite.h
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

#import <Foundation/Foundation.h>
#import "SKObject.h"
#import "SKSiteDelegate.h"
#import "SKDefinitions.h"

extern NSString * const SKSiteAPIKey;

@class SKUser;
@class SKFetchRequest;

@interface SKSite : SKObject {
	NSString * APIKey;
	NSURL * APIURL;
	
	NSTimeInterval timeoutInterval;
	
	NSOperationQueue * requestQueue;
	id<SKSiteDelegate> delegate;
}

@property (assign) id<SKSiteDelegate> delegate;
@property (copy) NSString * APIKey;
@property (readonly) NSURL * APIURL;
@property (readonly) NSString * APIVersion;

@property NSTimeInterval timeoutInterval;

+ (id) stackOverflowSite;

+ (id) stackOverflowSiteWithAPIKey:(NSString *)key;
+ (id) metaStackOverflowSiteWithAPIKey:(NSString *)key;
+ (id) stackAppsSiteWithAPIKey:(NSString *)key;
+ (id) serverFaultSiteWithAPIKey:(NSString *)key;
+ (id) superUserSiteWithAPIKey:(NSString *)key;

- (id) initWithAPIURL:(NSURL *)aURL APIKey:(NSString*)key;

- (id) isEqualToSite:(SKSite*)anotherSite;

- (SKUser *) userWithID:(NSNumber *)aUserID;

- (NSArray *) executeSynchronousFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error;
- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest;

#ifdef NS_BLOCKS_AVAILABLE
- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest withCompletionHandler:(SKFetchRequestCompletionHandler)handler;
#endif

- (NSDictionary *) statistics;
- (void) requestStatistics;

@end
