//
//  SKConstants.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct SKQueryParametersStruct {
    NSString *pageSize;
    NSString *page;
    NSString *site;
} SKQueryParameters;

extern const struct SKResponseKeysStruct {
    NSString *backOff;
    NSString *errorID;
    NSString *errorMessage;
    NSString *errorName;
    NSString *hasMore;
    NSString *items;
    NSString *page;
    NSString *pageSize;
    NSString *quotaMax;
    NSString *quotaRemaining;
    NSString *total;
    NSString *type;
} SKResponseKeys;