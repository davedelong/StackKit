//
//  SKRSS.m
//  RSS App
//
//  Created by Mark Suman on 1/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SKRSS.h"

@implementation SKRSS

+ (id) SKRSSWithURL:(NSURL *)aURL {
	return [[[SKRSS alloc] initWithURL:aURL] autorelease];
}

- (id) initWithURL:(NSURL *)aURL {
	if (self = [super init]) {
		haveDisplayedAlert = NO;
		url = [aURL retain];
		xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:aURL];
		
		// Note: Don't call setDelegate here. Classes who inherit from here will.
		[xmlParser setShouldProcessNamespaces:NO];
		[xmlParser setShouldReportNamespacePrefixes:NO];
		[xmlParser setShouldResolveExternalEntities:NO];
		
		elementStack = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[currentDate release];
	[currentTitle release];
	[currentSummary release];
	[currentLink release];
	[xmlParser release];
	[elementStack release];
	[super dealloc];
}

- (void) parse {
	[xmlParser parse];
}

- (void) setObserver:(id)anObserver selector:(SEL)selector {
	observer = anObserver;
	observerSelector = selector;
}

@end
