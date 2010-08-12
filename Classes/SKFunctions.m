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

BOOL SKIsVectorClass(id value) {
	return ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSSet class]]);
}

NSString * SKExtractVector(id value, SKExtractor extractor) {
	NSMutableSet * components = [NSMutableSet set];
	for (id component in value) {
		[components addObject:[extractor(component) description]];
	}
	return SKVectorizedCollection(components);
}

NSString * SKVectorizedCollection(id value) {
	if ([value isKindOfClass:[NSArray class]]) {
		return [value componentsJoinedByString:@";"];
	} else if ([value isKindOfClass:[NSSet class]]) {
		return SKVectorizedCollection([value allObjects]);
	}
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

id SKExtractUserID(id value) {
	if (SKIsVectorClass(value)) {
		return SKExtractVector(value, SKExtractUserID);
	}
	return SKExtractNumber(value, [SKUser class], @selector(userID));
}

id SKExtractBadgeID(id value) {
	if (SKIsVectorClass(value)) {
		return SKExtractVector(value, SKExtractBadgeID);
	}
	return SKExtractNumber(value, [SKBadge class], @selector(badgeID));
}

id SKExtractPostID(id value) {
	if (SKIsVectorClass(value)) {
		return SKExtractVector(value, SKExtractPostID);
	} else if ([value isKindOfClass:[SKAnswer class]]) {
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

id SKExtractCommentID(id value) {
	if (SKIsVectorClass(value)) {
		return SKExtractVector(value, SKExtractCommentID);
	}
	return SKExtractNumber(value, [SKComment class], @selector(commentID));
}

id SKExtractQuestionID(id value) {
	if (SKIsVectorClass(value)) {
		return SKExtractVector(value, SKExtractQuestionID);
	}
	return SKExtractNumber(value, [SKQuestion class], @selector(questionID));
}

id SKExtractAnswerID(id value) {
	if (SKIsVectorClass(value)) {
		return SKExtractVector(value, SKExtractAnswerID);
	}
	return SKExtractNumber(value, [SKAnswer class], @selector(answerID));
}

id SKExtractTagName(id value) {
	if (SKIsVectorClass(value)) {
		return SKExtractVector(value, SKExtractTagName);
	} else if ([value isKindOfClass:[NSString class]]) {
		return value;
	} else if ([value isKindOfClass:[SKTag class]]) {
		return [value name];
	} else {
		return [value description];
	}
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

void SKScanHexColor(NSString * hexString, float * red, float * green, float * blue, float * alpha) {
	NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if([cleanString length] == 3) {
		cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
					   [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
					   [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
					   [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
	}
	if([cleanString length] == 6) {
		cleanString = [cleanString stringByAppendingString:@"ff"];
	}
	
	unsigned int baseValue;
	[[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
	
	if (red) { *red = ((baseValue >> 24) & 0xFF)/255.0f; }
	if (green) { *green = ((baseValue >> 16) & 0xFF)/255.0f; }
	if (blue) { *blue = ((baseValue >> 8) & 0xFF)/255.0f; }
	if (alpha) { *alpha = ((baseValue >> 0) & 0xFF)/255.0f; }
}

#ifdef StackKitMobile

UIColor * SKColorFromHexString(NSString * hexString) {
	float red, green, blue, alpha;
	SKScanHexColor(hexString, &red, &green, &blue, &alpha);
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#else

NSColor * SKColorFromHexString(NSString * hexString) {
	float red, green, blue, alpha;
	SKScanHexColor(hexString, &red, &green, &blue, &alpha);
	
	return [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
}

#endif