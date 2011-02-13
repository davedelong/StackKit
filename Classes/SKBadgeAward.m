// 
//  SKBadgeAward.m
//  StackKit
//
//  Created by Dave DeLong on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKBadgeAward.h"

@implementation SKBadgeAward 

@dynamic badge;
@dynamic user;
@dynamic numberOfTimesAwarded;

SK_GETTER(NSNumber *, numberOfTimesAwarded);
SK_GETTER(SKUser *, user);
SK_GETTER(SKBadge *, badge);

@end
