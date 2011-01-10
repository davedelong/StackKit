//
//  Dummy.m
//  StackKit
//
//  Created by Dave DeLong on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StackKit/StackKit.h>

int main(int argc, char* argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	SKFetchRequest * r = [[SKFetchRequest alloc] init];
	[r setEntity:[SKAnswer class]];
	[r setPredicate:[NSPredicate predicateWithFormat:@"%K = %d", SKAnswerID, 1234]];
	
	NSError * e = nil;
	Class builder = NSClassFromString(@"SKRequestBuilder");
	NSURL * u = [builder URLForFetchRequest:r error:&e];
	
	NSLog(@"error: %@", e);
	NSLog(@"url: %@", u);
	
	[r release];
	
	[pool drain];
	return 0;
}