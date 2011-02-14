// 
//  SKBadgeAward.m
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKBadgeAward.h"
#import "SKMacros.h"

@implementation SKBadgeAward 

SK_GETTER(NSNumber *, numberOfTimesAwarded);
SK_GETTER(SKUser *, user);
SK_GETTER(SKBadge *, badge);

@end
