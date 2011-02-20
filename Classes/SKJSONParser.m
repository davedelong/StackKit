//
//  SKJSONParser.m
//  StackKit
//
//  Created by Dave DeLong on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKJSONParser.h"
#import "SKMacros.h"
#import "NSNumberFormatter+SKAdditions.h"

#define OBJECT_START @"{"
#define OBJECT_END @"}"
#define ARRAY_START @"["
#define ARRAY_END @"]"
#define STRING_START @"\""
#define STRING_END @"\""
#define NULL_START @"n"
#define TRUE_START @"t"
#define FALSE_START @"f"
#define COMMA @","
#define COLON @":"

#define SK_TRUE @"true"
#define SK_FALSE @"false"
#define SK_NULL @"null"

typedef struct {
    NSString *json;
    NSUInteger currentIndex;
    NSStringEncoding encoding;
} SKJSON;

id _SKParseNextObject(SKJSON *json);

NSString* _SKParsePeekNextChar(SKJSON *json);
NSString* _SKParseNextChar(SKJSON *json);

NSArray* _SKParseArray(SKJSON *json);
NSDictionary* _SKParseDictionary(SKJSON *json);

NSNumber* _SKParseNumber(SKJSON *json);
NSNull* _SKParseNull(SKJSON *json);
NSNumber* _SKParseTrue(SKJSON *json);
NSNumber* _SKParseFalse(SKJSON *json);
NSString* _SKParseString(SKJSON *json);

id SKParseJSON(NSString *json) {
    SKJSON jsonStruct;
    jsonStruct.json = json;
    jsonStruct.currentIndex = 0;
    jsonStruct.encoding = [json fastestEncoding];
    
    id returnValue = _SKParseNextObject(&jsonStruct);
    return returnValue;
}

BOOL _SKIsWhitespace(NSString *character) {
    return ([character isEqualToString:@" "] ||
            [character isEqualToString:@"\n"] ||
            [character isEqualToString:@"\r"] ||
            [character isEqualToString:@"\t"]);
}

NSRange _SKParseRangeOfNextChar(SKJSON *json, BOOL skipWhitespace) {
    NSRange r;
    do {
        r = [json->json rangeOfComposedCharacterSequenceAtIndex:json->currentIndex];
        if (skipWhitespace) {
            NSString *next = [json->json substringWithRange:r];
            if (_SKIsWhitespace(next)) {
                json->currentIndex = r.location+r.length;
            } else {
                break;
            }
        } else {
            break;
        }
    } while (1);
    return r;
}

NSString* _SKParsePeekNextChar(SKJSON *json) {
    NSRange r = _SKParseRangeOfNextChar(json, YES);
    NSString *next = [json->json substringWithRange:r];
    return next;
}

NSString* _SKParseNextChar(SKJSON *json) {
    NSRange r = _SKParseRangeOfNextChar(json, YES);
    NSString *next = [json->json substringWithRange:r];
    json->currentIndex = r.location+r.length;
    return next;
}

id _SKParseNextObject(SKJSON *json) {
    NSString *next = _SKParsePeekNextChar(json);
    if ([next isEqualToString:OBJECT_START]) {
        return _SKParseDictionary(json);
    } else if ([next isEqualToString:ARRAY_START]) {
        return _SKParseArray(json);
    } else if ([next isEqualToString:STRING_START]) {
        return _SKParseString(json);
    } else if ([next isEqualToString:NULL_START]) {
        return _SKParseNull(json);
    } else if ([next isEqualToString:TRUE_START]) {
        return _SKParseTrue(json);
    } else if ([next isEqualToString:FALSE_START]) {
        return _SKParseFalse(json);
    } else {
        // default to trying to parse a number.
        return _SKParseNumber(json);
    }
}

NSArray* _SKParseArray(SKJSON *json) {
    _SKParseNextChar(json); // consume the [
    NSMutableArray *array = [NSMutableArray array];
    NSString *peek = _SKParsePeekNextChar(json);
     while (![peek isEqualToString:ARRAY_END]) {
        id obj = _SKParseNextObject(json);
        if (!obj) { return nil; } // recursively we had an error
        [array addObject:obj];
        peek = _SKParsePeekNextChar(json);
        if ([peek isEqualToString:COMMA]) {
            _SKParseNextChar(json); // consume the ,
            peek = _SKParsePeekNextChar(json);
            if ([peek isEqualToString:ARRAY_END]) {
                SKLog(@"JSON: a ] cannot immediately follow a , in an array");
                return nil;
            }  // a ] cannot immediately follow a , in an array
        }
    }
    
    _SKParseNextChar(json); // consume the ]
    return array;
}

NSDictionary* _SKParseDictionary(SKJSON *json) {
    _SKParseNextChar(json); // consume the {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    NSString *peek = _SKParsePeekNextChar(json);
    while ([peek isEqualToString:STRING_START]) {
        NSString *name = _SKParseString(json);
        if (!name) {
            SKLog(@"JSON: an object field name must be a string");
            return nil;
        }
        NSString *colon = _SKParseNextChar(json);
        if (![colon isEqualToString:COLON]) {
            SKLog(@"JSON: an object field name must be followed by a :");
            return nil;
        }
        id value = _SKParseNextObject(json);
        if (!value) {
            return nil;
        }
        [d setObject:value forKey:name];
        
        peek = _SKParsePeekNextChar(json);
        if ([peek isEqualToString:OBJECT_END]) {
            break;
        }
        if (![peek isEqualToString:COMMA]) {
            SKLog(@"JSON: object values must be followed by a } or ,");
            return nil;
        }
        _SKParseNextChar(json); // consume the comma
        peek = _SKParsePeekNextChar(json);
    }
    if (![peek isEqualToString:OBJECT_END]) {
        SKLog(@"JSON: an object must end with }");
        return nil;
    }
    _SKParseNextChar(json); // consume the }
    return d;
}

NSNumber* _SKParseNumber(SKJSON *json) {
    
    NSMutableString *s = [NSMutableString string];
    NSNumber *lastGoodNumber = nil;
    do {
        NSString *peek = _SKParsePeekNextChar(json);
        [s appendString:peek];
        
        NSNumber *thisNumber = [[NSNumberFormatter sk_basicFormatter] numberFromString:s];
        if (thisNumber != nil) {
            _SKParseNextChar(json); // consume the characters
            lastGoodNumber = thisNumber;
        } else {
            break;
        }
    } while(1);
    
    if (lastGoodNumber == nil) {
        SKLog(@"JSON: invalid syntax; unable to parse number");
    }
    return lastGoodNumber;    
}

NSNull* _SKParseNull(SKJSON *json) {
    NSRange r;
    r.location = json->currentIndex;
    r.length = [SK_NULL length]; // [@"null" length]
    NSString *n = [json->json substringWithRange:r];
    if (![n isEqualToString:SK_NULL]) {
        SKLog(@"JSON: expected 'null', got %@", n);
        return nil;
    }
    json->currentIndex += [SK_NULL length];
    return [NSNull null];
}

NSNumber* _SKParseTrue(SKJSON *json) {
    NSRange r;
    r.location = json->currentIndex;
    r.length = [SK_TRUE length]; // [@"true" length]
    NSString *n = [json->json substringWithRange:r];
    if (![n isEqualToString:SK_TRUE]) {
        SKLog(@"JSON: expected 'true', got %@", n);
        return nil;
    }
    json->currentIndex += [SK_TRUE length];
    return [NSNumber numberWithBool:YES];
}

NSNumber* _SKParseFalse(SKJSON *json) {
    NSRange r;
    r.location = json->currentIndex;
    r.length = [SK_FALSE length]; // [@"true" length]
    NSString *n = [json->json substringWithRange:r];
    if (![n isEqualToString:SK_FALSE]) {
        SKLog(@"JSON: expected 'false', got %@", n);
        return nil;
    }
    json->currentIndex += [SK_FALSE length];
    return [NSNumber numberWithBool:NO];
}

NSString* _SKParseString(SKJSON *json) {    
    NSMutableString *s = [NSMutableString string];
    _SKParseNextChar(json); // consume the "
    
    BOOL escaping = NO;
    do {
        // can't use PeekNextChar and NextChar because those skip whitespace
        NSRange charRange = _SKParseRangeOfNextChar(json, NO);
        NSString *character = [json->json substringWithRange:charRange];
        json->currentIndex = charRange.location+charRange.length;
        
        if (escaping == YES) {
            escaping = NO;
        } else {
            if ([character isEqualToString:@"\\"]) {
                NSRange peekRange = _SKParseRangeOfNextChar(json, NO);
                NSString *peek = [json->json substringWithRange:peekRange];
                
                BOOL consume = YES;
                if ([peek isEqualToString:@"n"]) {
                    character = @"\n";
                } else if ([peek isEqualToString:@"r"]) {
                    character = @"\r";
                } else if ([peek isEqualToString:@"t"]) {
                    character = @"\t";
                } else if ([peek isEqualToString:@"u"]) {
                    character = character; // TODO: consume 4 bytes with the proper encoding
                } else if ([peek isEqualToString:@"x"]) {
                    character = character; // TODO: consume 2 hex bytes
                } else if ([peek isEqualToString:@"b"]) {
                    character = @"\b";
                } else {
                    consume = NO;
                }
                
                if (consume == YES) {
                    json->currentIndex = peekRange.location+peekRange.length;
                }
            } else if ([character isEqualToString:STRING_END]) {
                break;
            }
        }
        
        [s appendString:character];
        
    } while(1);
    
    return s;
}

NSString* _SKParseUnicodeCharacter(SKJSON *json) {
    SKLog(@"executing unfinished function: %s", __PRETTY_FUNCTION__);
    return nil;
}
