//
//  SKAssociatedUserOperation.m
//  StackKit
//
//  Created by Dave DeLong on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKAssociatedUserOperation.h"
#import "SKConstants.h"
#import "SKConstants_Internal.h"
#import "SKUser+Private.h"
#import "NSDictionary+SKAdditions.h"
#import "SKJSONParser.h"

@implementation SKAssociatedUserOperation
@synthesize handler;

- (id) initWithUser:(SKUser *)user handler:(SKRequestHandler)completionHandler {
    NSString * associationID = [user associationID];
    if (associationID == nil) {
        [self release];
        return nil;
    }
    
    self = [super initWithSite:[user site]];
    if (self) {
        baseUser = [user retain];
        [self setHandler:completionHandler];
    }
    return self;
}

- (void) dealloc {
    [baseUser release];
    [handler release];
    [super dealloc];
}

- (void) main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSUInteger total = NSUIntegerMax;
    NSMutableArray *objects = [NSMutableArray array];
    NSUInteger currentPage = 1;
    NSUInteger lastCount = NSUIntegerMax;
    
    while ([objects count] < total) {
        NSMutableDictionary *query = [NSMutableDictionary dictionary];
        [query setObject:[NSNumber numberWithUnsignedInteger:currentPage] forKey:SKQueryPage];
        [query setObject:[NSNumber numberWithUnsignedInteger:SKPageSizeLimitMax] forKey:SKQueryPageSize];
        
        NSString *url = [NSString stringWithFormat:@"http://stackauth.com/%@/users/%@/associated?%@", SKAssociationAPIVersion, [baseUser associationID], [query sk_queryString]];
        
        NSURL *requestURL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
        
        NSURLResponse * response = nil;
        NSError * connectionError = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
        
        NSString * responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        
        NSDictionary * responseObjects = SKParseJSON(responseString);
        if ([responseObjects isKindOfClass:[NSDictionary class]] == NO) {
            objects = nil;
            break;
        }
		
		//this because the 1.1 stackauth api methods aren't great, 1.0 returns more detail
        NSNumber *totalNumberOfItems;
        if ([SKAssociationAPIVersion isEqualToString:@"1.0"]) {
			totalNumberOfItems = [NSNumber numberWithInt:[[responseObjects objectForKey:@"associated_users"] count]];
		} else {
			totalNumberOfItems = [responseObjects objectForKey:@"total"];
		}
        if (total != [totalNumberOfItems unsignedIntegerValue]) {
            total = [totalNumberOfItems unsignedIntegerValue];
        }
        NSArray *items;
        if ([SKAssociationAPIVersion isEqualToString:@"1.0"]) {
			items = [responseObjects objectForKey:@"associated_users"];
		} else {
			items = [responseObjects objectForKey:@"items"];
		}
			 
        for (NSDictionary *item in items) {
            SKUser *user = [SKUser userWithAssociationInformation:item];
            if (user != nil) {
                [objects addObject:user];
            }
        }
        
        //also break if we didn't get any objects on this loop
        NSUInteger currentCount = [objects count];
        if (currentCount == lastCount) {
            break;
        }
        
        lastCount = [objects count];
        currentPage++;
    }
    
    SKRequestHandler h = [self handler];
    dispatch_async(dispatch_get_main_queue(), ^{
        h(objects); 
    });
    
    [pool drain];
}

@end
