//
//  SKRSS.h
//  RSS App
//
//  Created by Mark Suman on 1/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

@interface SKRSS : SKObject {
	NSMutableArray *elementStack;
	
	NSURL *url;
	NSXMLParser *xmlParser;
	
	NSMutableString *currentTitle;
	NSMutableString *currentDate; 
	NSMutableString *currentSummary;
	NSMutableString *currentLink;
	
	id observer;
	SEL observerSelector;
	BOOL haveDisplayedAlert;
}

+ (id) SKRSSWithURL:(NSURL *)aURL;
- (id) initWithURL:(NSURL *)aURL;
- (void) parse;
- (void) setObserver:(id)anObserver selector:(SEL)selector;

@end
