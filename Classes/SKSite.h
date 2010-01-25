//
//  SKSite.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKSite : SKObject {
	NSURL * siteURL;
}

@property (readonly) NSURL * siteURL;

- (id) initWithURL:(NSURL *)aURL;

@end
