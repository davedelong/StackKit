//
//  SKObject.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSite;

@interface SKObject : NSObject {
	__weak SKSite * site;
}

@property (readonly) SKSite * site;

- (id) initWithSite:(SKSite *)aSite;

@end
