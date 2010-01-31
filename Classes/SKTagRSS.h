//
//  SKTagRSS.h
//  StackKit
//
//  Created by Mark Suman on 1/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SKRSS.h"

@class SKTag;

@interface SKTagRSS : SKRSS < NSXMLParserDelegate >{
	NSMutableArray * questions;
}

@property (nonatomic,retain) NSMutableArray * questions;

+ (id) SKTagRSSWithSite:(SKSite *)aSite tag:(SKTag *)aURL;
- (id) initWithSite:(SKSite *)aSite tag:(SKTag *)aTag;

@end
