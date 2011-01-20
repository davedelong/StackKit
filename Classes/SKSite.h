//
//  SKSite.h
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
#import "SKSiteDelegate.h"
#import "SKDefinitions.h"

extern NSString * const SKSiteAPIKey;

extern NSString * const SKSiteStylingLinkColor;
extern NSString * const SKSiteStylingTagColor;
extern NSString * const SKSiteStylingTagBackgroundColor;

typedef enum {
	SKSiteStateNormal = 0,
	SKSiteStateLinkedMeta = 1,
	SKSiteStateOpenBeta = 2,
	SKSiteStateClosedBeta = 3
} SKSiteState;

@class SKUser;
@class SKFetchRequest;

@interface SKSite : SKObject {
	NSString * apiKey;
	NSURL * apiURL;
	NSString * name;
	NSURL * siteURL;
	NSURL * logoURL;
	NSURL * iconURL;
	NSString * summary;
	
	SKSiteState state;
	
	NSDictionary * stylingInformation;
	
	NSTimeInterval timeoutInterval;
	
	NSOperationQueue * requestQueue;
	id<SKSiteDelegate> delegate;
}

@property (assign) id<SKSiteDelegate> delegate;
@property (copy) NSString * apiKey;
@property (readonly) NSURL * apiURL;
@property (readonly) NSString * apiVersion;

@property (readonly) NSString * name;
@property (readonly) NSURL * siteURL;
@property (readonly) NSURL * logoURL;
@property (readonly) NSURL * iconURL;
@property (readonly) NSString * summary;
@property (readonly) SKSiteState state;
@property (readonly) NSDictionary * stylingInformation;

@property NSTimeInterval timeoutInterval;

+ (NSArray *) knownSites;

+ (id) siteWithAPIURL:(NSURL *)aURL;

+ (id) stackOverflowSite;
+ (id) metaStackOverflowSite;
+ (id) stackAppsSite;
+ (id) serverFaultSite;
+ (id) superUserSite;

- (SKSite *) qaSite;
- (SKSite *) metaSite;
- (SKSite *) companionSite;

- (BOOL) isEqualToSite:(SKSite*)anotherSite;

- (SKUser *) userWithID:(NSNumber *)aUserID;

- (NSArray *) executeSynchronousFetchRequest:(SKFetchRequest *)fetchRequest error:(NSError **)error;
- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest;

#ifdef NS_BLOCKS_AVAILABLE
- (void) executeFetchRequest:(SKFetchRequest *)fetchRequest withCompletionHandler:(SKFetchRequestCompletionHandler)handler;
#endif

- (NSDictionary *) statistics;
- (void) requestStatistics;

@end
