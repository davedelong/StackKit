//
//  SKTagRSS.m
//  StackKit
//
//  Created by Mark Suman on 1/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SKTagRSS.h"
#import "SKSite.h"
#import "SKQuestion.h"

@implementation SKTagRSS

@synthesize questions;

+ (id) SKTagRSSWithSite:(SKSite *)aSite tag:(SKTag *)aTag {
	return [[[SKTagRSS alloc] initWithSite:aSite tag:aTag] autorelease];
}

- (id) initWithSite:(SKSite *)aSite tag:(SKTag *)aTag {
	NSURL * u = [[[aSite siteURL] 
				URLByAppendingPathComponent:@"feeds/tag"] 
				URLByAppendingPathComponent:[aTag name]];
	
	if (self = [super initWithURL:u]) {
		[xmlParser setDelegate:self];
		questions = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	[questions release];
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	if (haveDisplayedAlert == NO) {
		NSString * errorString = [NSString stringWithFormat:@"Unable to download feed (Error code %i ).  Please check your internet connection and try again.", [parseError code]];
		NSLog(@"parseErrorOccurred: %@",errorString);
		haveDisplayedAlert = YES;
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
	[elementStack addObject:elementName];

	if ([elementName isEqualToString:@"entry"]) {
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	if ([elementName isEqualToString:@"entry"]) {
		NSArray * linkComponents = [currentLink pathComponents];
		SKQuestion * q = [[SKQuestion alloc] initWithSite:[self site] postID:[linkComponents objectAtIndex:[linkComponents count]-2]];
		[questions addObject:q];
		[q release];

		[currentTitle release]; currentTitle = nil;
		[currentDate release]; currentDate = nil;
		[currentSummary release]; currentSummary = nil;
		[currentLink release]; currentLink = nil;
	}
	[elementStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if ([[elementStack lastObject] isEqualToString:@"title"] && [[elementStack objectAtIndex:[elementStack count]-2] isEqualToString:@"entry"]) {
		[currentTitle appendString:string];
	} else if ([[elementStack lastObject] isEqualToString:@"id"] && [[elementStack objectAtIndex:[elementStack count]-2] isEqualToString:@"entry"]) {
		[currentLink appendString:string];
	} else if ([[elementStack lastObject] isEqualToString:@"summary"] && [[elementStack objectAtIndex:[elementStack count]-2] isEqualToString:@"entry"]) {
		[currentSummary appendString:string];
	} else if ([[elementStack lastObject] isEqualToString:@"published"] && [[elementStack objectAtIndex:[elementStack count]-2] isEqualToString:@"entry"]) {
		[currentDate appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	// Done
}


@end
