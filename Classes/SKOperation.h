//
//  SKOperation.h
//  StackKit
//
//  Created by Dave DeLong on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSite.h"

@interface SKOperation : NSOperation {
    
}

@property (nonatomic, retain) SKSite * site;

- (id) initWithSite:(SKSite *)baseSite;

@end
