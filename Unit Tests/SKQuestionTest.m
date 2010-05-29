//
//  SKQuestionTest.m
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKQuestionTest.h"
#import "SKTestConstants.h"
#import <StackKit/StackKit.h>

@implementation SKQuestionTest

- (void) testQuestion {
	SKSite * site = [SKSite stackoverflowSite];
	
	SKQuestion * q = [[SKQuestion alloc] initWithSite:site postID:[NSNumber numberWithUnsignedInteger:1283419]];
	
	STAssertEqualObjects([q title], @"Valid use of accessors in init and dealloc methods?", @"Unexpected title");
	STAssertTrue([q voteCount] == 7, @"Unexpected vote count");
	STAssertTrue([q viewCount] == 269, @"Unexpected view count");
	STAssertTrue([q favoritedCount] == 2, @"Unexpected favorited count");
	STAssertTrue([q upVotes] == 7, @"Unexpected upvote count");
	STAssertTrue([q downVotes] == 0, @"Unexpected downvote count");
	
	[q release];
}

@end
