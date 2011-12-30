//
//  SKConstants.m
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKConstants.h"

const struct SKQueryParametersStruct SKQueryParameters = {
    .pageSize   = @"pagesize",
    .page       = @"page",
    .site       = @"site"
};


const struct SKResponseKeysStruct SKResponseKeys = {
    .backOff            = @"backoff",
    .errorID            = @"error_id",
    .errorMessage       = @"error_message",
    .errorName          = @"error_name",
    .hasMore            = @"has_more",
    .items              = @"items",
    .page               = @"page",
    .pageSize           = @"page_size",
    .quotaMax           = @"quota_max",
    .quotaRemaining     = @"quota_remaining",
    .total              = @"total",
    .type               = @"type"
};
