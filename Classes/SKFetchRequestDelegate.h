//
//  SKFetchRequestDelegate.h
//  StackKit
//
//  Created by Dave DeLong on 5/24/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKFetchRequest;

@protocol SKFetchRequestDelegate <NSObject>

@optional
- (void) fetchRequestWillBeginExecuting:(SKFetchRequest *)request;
- (void) fetchRequestDidFinishExecuting:(SKFetchRequest *)request;

- (void) fetchRequest:(SKFetchRequest *)request didReturnResults:(NSArray *)results;
- (void) fetchRequest:(SKFetchRequest *)request didFailWithError:(NSError *)error;

@end
