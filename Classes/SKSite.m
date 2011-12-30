//
//  SKSite.m
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKSite.h"
#import <StackKit/StackKit_Internal.h>
#import <objc/runtime.h>

dispatch_queue_t SKSiteQueue();

static NSArray *SKGetSites();

static NSMutableArray *SKSites();
void SKFetchSites();

static NSString *SKSiteCacheKeyDate = @"cacheDate";
static NSString *SKSiteCacheKeyObjects = @"objects";
NSString* SKSiteCachePath();
NSArray* SKGetCachedSites();
void SKSetCachedSites(NSArray *sitesJSON);

@implementation SKSite {
    NSDictionary *_info;
}

@dynamic name;
@dynamic audience;
@dynamic launchDate;

@dynamic logoURL;
@dynamic siteURL;
@dynamic iconURL;
@dynamic faviconURL;

+ (void)requestSitesWithCompletionHandler:(SKSomething)handler {
    handler = [handler copy];
    
    dispatch_async(SKSiteQueue(), ^{
        
        NSArray *result = SKGetSites();
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(result);
        });
    });
    
    [handler release];
}

#pragma mark -
#pragma mark SKSite Instance Stuff

+ (NSDictionary *)APIToObjectMappping {
    static dispatch_once_t onceToken;
    static NSDictionary *map = nil;
    dispatch_once(&onceToken, ^{
        map = [[NSDictionary alloc] initWithObjectsAndKeys:
               @"name", SKResponseKeys.site.name,
               @"audience", SKResponseKeys.site.audience,
               @"launchDate", SKResponseKeys.site.launchDate,
               @"logoURL", SKResponseKeys.site.logoURL,
               @"siteURL", SKResponseKeys.site.siteURL,
               @"iconURL", SKResponseKeys.site.iconURL,
               @"faviconURL", SKResponseKeys.site.faviconURL,
               nil];
    });
    return map;
}

+ (NSDictionary *)objectToAPIMapping {
    static dispatch_once_t onceToken;
    static NSDictionary *map = nil;
    dispatch_once(&onceToken, ^{
        NSDictionary *otherMap = [self APIToObjectMappping];
        NSArray *keys = [otherMap allKeys];
        NSArray *values = [otherMap objectsForKeys:keys notFoundMarker:[NSNull null]];
        
        // the keys from the other map become the objects in this map
        map = [[NSDictionary alloc] initWithObjects:keys forKeys:values];
    });
    return map;
}

+ (id)allocWithZone:(NSZone *)zone {
    [NSException raise:NSInternalInconsistencyException format:@"You may not allocate an SKSite object"];
    return nil;
}

- (id)_initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        _info = [info retain];
    }
    return self;
}

- (void)dealloc {
    [_info release];
    [super dealloc];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    objc_property_t property = class_getProperty(self, sel_getName(sel));
    if (property == NULL) { return NO; }
    
    char *value = property_copyAttributeValue(property, "T");
    int length = strlen(value);
    
    NSString *apiKey = [[self objectToAPIMapping] objectForKey:NSStringFromSelector(sel)];
    
    Class returnType = [NSString class];
    
    if (length > 3) {
        NSString *className = [[NSString alloc] initWithBytes:value+2 length:length-3 encoding:NSUTF8StringEncoding];
        returnType = NSClassFromString(className);
        [className release];
    }
    
    id(^impBlock)(SKSite *) = ^(SKSite *_s){
        NSDictionary *info = _s->_info;
        id value = [info objectForKey:apiKey];
        
        if (returnType == [NSURL class]) {
            value = [NSURL URLWithString:value];
        } else if (returnType == [NSDate class]) {
            value = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }
        
        return value;
    };
    
    IMP newIMP = imp_implementationWithBlock((void *)impBlock);
    class_addMethod(self, sel, newIMP, "@@:");
    
    return YES;
}

@end

static NSArray *SKGetSites() {
    if ([SKSites() count] == 0) {
        SKFetchSites();
    }
    
    return [[SKSites() copy] autorelease];
}

dispatch_queue_t SKSiteQueue() {
    static dispatch_once_t onceToken;
    static dispatch_queue_t siteQueue;
    dispatch_once(&onceToken, ^{
        siteQueue = dispatch_queue_create("com.davedelong.stackkit.sksite", 0);
    });
    return siteQueue;
}

NSMutableArray *SKSites() {
    static dispatch_once_t onceToken;
    static NSMutableArray *sites = nil;
    dispatch_once(&onceToken, ^{
        sites = [[NSMutableArray alloc] init];
    });
    return sites;
}

NSString* SKSiteCachePath() {
    return [SKApplicationSupportDirectory() stringByAppendingPathComponent:@"sites.plist"];
}

NSArray* SKGetCachedSites() {
    NSString *cacheFile = SKSiteCachePath();
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:cacheFile];
    NSDate *cacheDate = [d objectForKey:SKSiteCacheKeyDate];
    
    NSTimeInterval cacheInterval = [cacheDate timeIntervalSinceReferenceDate];
    NSTimeInterval nowInterval = [NSDate timeIntervalSinceReferenceDate];
    
    // go with approximately a day
    if (fabs(cacheInterval - nowInterval) > 86400) {
        d = nil;
    }
    
    return [d objectForKey:SKSiteCacheKeyObjects];
}

void SKSetCachedSites(NSArray *sitesJSON) {
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
                       sitesJSON, SKSiteCacheKeyObjects,
                       [NSDate date], SKSiteCacheKeyDate, 
                       nil];
    
    [d writeToFile:SKSiteCachePath() atomically:YES];
}

void SKFetchSites() {
    // this function will:
    // 1. fetch all data from stackauth
    // 2. cache the json
    // 3. convert the json to SKSite objects
    // 4. save the SKSite objects into the SKSites() array
    
    NSMutableArray *allItems = [NSMutableArray array];
    NSUInteger currentPage = 1;
    NSUInteger pageSize = 100;
    BOOL keepGoing = YES;
    
    while (keepGoing) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        {
            NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithUnsignedInteger:currentPage], SKQueryParameters.page,
                                          [NSNumber numberWithUnsignedInteger:pageSize], SKQueryParameters.pageSize,
                                          nil];
            
            NSURL *requestURL = SKConstructAPIURL(@"sites", query);
            NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
            
            NSURLResponse * response = nil;
            NSError * connectionError = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
            
            NSDictionary *responseObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([responseObjects isKindOfClass:[NSDictionary class]] == NO) {
                allItems = nil;
                break;
            }
            
            NSArray *items = [responseObjects objectForKey:@"items"];
            [allItems addObjectsFromArray:items];
            
            currentPage++;
            
            NSNumber *keepGoingNumber = [responseObjects objectForKey:@"has_more"];
            keepGoing = [keepGoingNumber boolValue];
        }
        [pool release];
    }
    
    // 2: cache the json
    SKSetCachedSites(allItems);
    
    // 3: convert the json to SKSite objects
    NSMutableArray *sites = SKSites();
    for (NSDictionary *item in allItems) {
        SKSite *site = NSAllocateObject([SKSite class], 0, nil);
        [site _initWithInfo:item];
        
        // 4: save the SKSites into the SKSites() array
        [sites addObject:site];
        [site release];
    }
}
