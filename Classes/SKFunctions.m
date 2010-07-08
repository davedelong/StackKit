//
//  SKFunctions.m
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

#import "StackKit_Internal.h"

void SKQLog(NSString *format, ...) {
	if (format == nil) {
		printf("(null)\n");
		return;
	}
	// Get a reference to the arguments that follow the format parameter
	va_list argList;
	va_start(argList, format);
	// Do format string argument substitution, reinstate %% escapes, then print
	NSMutableString *string = [[NSMutableString alloc] initWithFormat:format
	                                                        arguments:argList];
	NSRange range;
	range.location = 0;
	range.length = [string length];
	[string replaceOccurrencesOfString:@"%%" withString:@"%%%%" options:0 range:range];
	printf("%s\n", [string UTF8String]);
	[string release];
	va_end(argList);
}

id SKInvalidPredicateErrorForFetchRequest(SKFetchRequest * request, NSDictionary * userInfo) {
	[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:userInfo]];
	return nil;
}

NSNumber * SKExtractNumber(id object, Class type, SEL idGetter) {
	if ([object isKindOfClass:type]) {
		return [object performSelector:idGetter];
	} else if ([object isKindOfClass:[NSNumber class]]) {
		return object;
	} else {
		return [NSNumber numberWithInt:[[object description] intValue]];
	}
}

NSNumber * SKExtractUserID(id value) {
	return SKExtractNumber(value, [SKUser class], @selector(userID));
}

NSNumber * SKExtractBadgeID(id value) {
	return SKExtractNumber(value, [SKBadge class], @selector(badgeID));
}

NSArray * SKExtractBadgeIDs(id value) {
	if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSSet class]]) {
		NSMutableArray * values = [NSMutableArray array];
		for (id badge in value) {
			[values addObject:SKExtractBadgeID(badge)];
		}
		return values;
	}
	
	id badge = SKExtractBadgeID(value);
	if (badge) {
		return [NSArray arrayWithObject:badge];
	}
	
	return nil;
}

NSNumber * SKExtractPostID(id value) {
	if ([value isKindOfClass:[SKAnswer class]]) {
		return SKExtractAnswerID(value);
	} else if ([value isKindOfClass:[SKQuestion class]]) {
		return SKExtractQuestionID(value);
	} else if ([value isKindOfClass:[SKComment class]]) {
		return SKExtractCommentID(value);
	} else {
		//we can call this with SKPost because it's abstract
		return SKExtractNumber(value, [SKPost class], @selector(postID));
	}
}

NSNumber * SKExtractCommentID(id value) {
	return SKExtractNumber(value, [SKComment class], @selector(commentID));
}

NSNumber * SKExtractQuestionID(id value) {
	return SKExtractNumber(value, [SKQuestion class], @selector(questionID));
}

NSNumber * SKExtractAnswerID(id value) {
	return SKExtractNumber(value, [SKAnswer class], @selector(answerID));
}

NSString * SKExtractTagName(id value) {
	if ([value isKindOfClass:[NSString class]]) {
		return value;
	} else if ([value isKindOfClass:[SKTag class]]) {
		return [value name];
	} else {
		return [value description];
	}
}

NSArray * SKExtractTagNames(id value) {
	//we can only extract multiple names out of a collection:
	if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSSet class]]) {
		NSMutableArray * names = [NSMutableArray array];
		for (id tagValue in value) {
			[names addObject:SKExtractTagName(tagValue)];
		}
		return names;
	} else if ([value isKindOfClass:[NSString class]]) {
		return [NSArray arrayWithObject:value];
	}
	return nil;
}

NSDate * SKExtractDate(id value) {
	if ([value isKindOfClass:[NSDate class]]) {
		return value;
	} else if ([value isKindOfClass:[NSNumber class]]) {
		return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
	} else {
		return [NSDate dateWithTimeIntervalSince1970:[[value description] doubleValue]];
	}
}

NSUInteger SKExtractInteger(id value) {
	if ([value isKindOfClass:[NSNumber class]]) {
		return [value unsignedIntegerValue];
	} else if ([value isKindOfClass:[NSDate class]]) {
		NSTimeInterval interval = [value timeIntervalSince1970];
		NSNumber * boxedInterval = [NSNumber numberWithDouble:interval];
		return [boxedInterval unsignedIntegerValue];
	} else {
		return [[value description] integerValue];
	}
}