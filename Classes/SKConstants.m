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
    .type               = @"type",
    .site = {
        .siteType = @"site_type",
        .name = @"name",
        .logoURL = @"logo_url",
        .apiSiteParameter = @"api_site_parameter",
        .siteURL = @"site_url",
        .audience = @"audience",
        .iconURL = @"icon_url",
        .aliases = @"aliases",
        .siteState = @"site_state",
        .styling = @"styling",
        .stylingKeys = {
            .linkColor = @"link_color",
            .tagForegroundColor = @"tag_foreground_color",
            .tagBackgroundColor = @"tag_background_color"
        },
        .launchDate = @"launch_date",
        .faviconURL = @"faviconURL",
        .relatedSites = @"related_sites",
        .relatedSiteKeys = {
            .name = @"name",
            .siteURL = @"site_url",
            .relation = @"relation"
        },
        .markdownExtensions = @"markdown_extensions"
    }
};
