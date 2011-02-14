//
//  SKSiteStatistics+Private.h
//  StackKit
//
//  Created by Dave DeLong on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKSiteStatistics ()

+ (id)statsForSite:(SKSite*)site withResponseDictionary:(NSDictionary*)responseDictionary;
- (id)initWithSite:(SKSite*)site responseDictionary:(NSDictionary*)responseDictionary;

@end
