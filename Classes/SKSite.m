//
//  SKSite.m
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKSite_Internal.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKCache.h>
#import <StackKit/SKSiteCache.h>
#import <StackKit/SKRequestManager.h>

@interface SKSite()

@end

@implementation SKSite {
    SKRequestManager *_requestManager;
}

@dynamic name;
@dynamic audience;
@dynamic launchDate;

@dynamic logoURL;
@dynamic siteURL;
@dynamic iconURL;
@dynamic faviconURL;

@dynamic APISiteParameter;

+ (void)requestSitesWithCompletionHandler:(SKRequestHandler)handler {
    [[SKSiteCache sharedSiteCache] requestAllSitesWithCompletionHandler:handler];
}

+ (void)requestSiteWithNameLike:(NSString *)name completionHandler:(SKSiteHandler)handler {
    handler = [handler copy];
    
    NSArray *words = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    SKRequestHandler block = ^(NSArray *sites, NSError *error) {
        // this will be called on the main thread
        if (sites) {
            NSPredicate *template = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] $word OR audience CONTAINS[cd] $word or siteURL.absoluteString CONTAINS[cd] $word"];
            
            for (NSString *word in words) {
                if ([word length] == 0) { continue; }
                NSPredicate *p = [template predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:word forKey:@"word"]];
                sites = [sites filteredArrayUsingPredicate:p];
            }
            
            SKSite *match = nil;
            if ([sites count] > 0) {
                match = [sites objectAtIndex:0];
            }
            
            handler(match, nil);
        } else {
            handler(nil, error);
        }
    };
    
    [self requestSitesWithCompletionHandler:block];
    
    [handler release];
}

+ (void)requestSitesWithNames:(NSArray *)names completionHandler:(SKRequestHandler)handler {
    handler = [handler copy];
    [self requestSitesWithCompletionHandler:^(NSArray *sites, NSError *error) {
        NSArray *filtered = nil;
        if (sites) {
            NSArray *siteNames = [sites valueForKey:@"name"];
            NSDictionary *map = [NSDictionary dictionaryWithObjects:sites forKeys:siteNames];
            filtered = [map objectsForKeys:names notFoundMarker:[NSNull null]];
        }
        handler(filtered,error);
    }];
    [handler release];
}

#pragma mark -
#pragma mark SKSite Instance Stuff

+ (NSArray *)APIKeysBackingProperties {
    static dispatch_once_t onceToken;
    static NSArray *array = nil;
    dispatch_once(&onceToken, ^{
        array = [[NSArray alloc] initWithObjects:
                 SKAPIKeys.site.name,
                 SKAPIKeys.site.audience,
                 SKAPIKeys.site.launchDate,
                 SKAPIKeys.site.logoURL,
                 SKAPIKeys.site.siteURL,
                 SKAPIKeys.site.iconURL,
                 SKAPIKeys.site.faviconURL,
                 SKAPIKeys.site.siteState,
                 SKAPIKeys.site.apiSiteParameter,
                 nil];
    });
    return array;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSDictionary *info = [aDecoder decodeObjectForKey:@"info"];
    return [self _initWithInfo:info site:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self _info] forKey:@"info"];
}

- (id)_initWithInfo:(id)info site:(SKSite *)site {
    self = [super _initWithInfo:info site:nil];
    if (self) {
        _requestManager = [[SKRequestManager requestManagerWithSite:self] retain];
    }
    return self;
}

- (void)dealloc {
    [_requestManager release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ {name = %@, url = %@}", 
            [super description],
            [self name],
            [self siteURL]];
}

// this has a non-object return type, so we'll override the getter manually
- (SKSiteState)siteState {
    NSString *value = [self _valueForInfoKey:SKAPIKeys.site.siteState];
    SKSiteState s = SKSiteStateNormal;

    if ([value isEqualToString:@"linked_meta"]) {
        s = SKSiteStateLinkedMeta;
    } else if ([value isEqualToString:@"open_beta"]) {
        s = SKSiteStateOpenBeta;
    } else if ([value isEqualToString:@"closed_beta"]) {
        s = SKSiteStateClosedBeta;
    }
    return s;
}

- (SKSite *)site {
    return self;
}

- (void)executeFetchRequest:(SKFetchRequest *)request completionHandler:(SKRequestHandler)handler {
    [_requestManager executeRequest:request asynchronously:YES completionHandler:handler];
}

@end
