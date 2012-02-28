//
//  SKFunctions.m
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKMacros.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKTypes.h>
#import <StackKit/SKResponse.h>

NSString* SKApplicationSupportDirectory() {
    static dispatch_once_t onceToken;
    static NSString *asd = nil;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        
#if StackKitMac
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        if ([executableName length] == 0) {
            executableName = [[NSProcessInfo processInfo] processName];
        }
        basePath = [basePath stringByAppendingPathComponent:executableName];
#endif
        
        asd = [[basePath stringByAppendingPathComponent:@"StackKit"] retain];
        
        BOOL isDir = NO;
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        if ([fm fileExistsAtPath:asd isDirectory:&isDir] == NO || isDir == NO) {
            NSError *error = nil;
            if (![fm createDirectoryAtPath:asd withIntermediateDirectories:YES attributes:nil error:&error]) {   
                SKLog(@"Error creating application support directory at %@ : %@", asd, error);
            }
        }
        [fm release];
    });
    
    return asd;
}

NSBundle* SKBundle() {
    static dispatch_once_t onceToken;
    static NSBundle *stackKitBundle = nil;
    dispatch_once(&onceToken, ^{
        stackKitBundle = [[NSBundle bundleForClass:NSClassFromString(@"SKSite")] retain];
    });
    return stackKitBundle;
}

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

NSString* SKQueryString(id object) {
    NSString *result = nil;
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *pairs = [[NSMutableArray alloc] init];
        for (NSString *key in object) {
            id value = [object objectForKey:key];
            
            NSString *pair = [NSString stringWithFormat:@"%@=%@", SKQueryString(key), SKQueryString(value)];
            [pairs addObject:pair];
        }
        result = [pairs componentsJoinedByString:@"&"];
        
        [pairs release];
    } else if ([object conformsToProtocol:@protocol(NSFastEnumeration)]) {
        // any sort of collection of objects (NSSet, NSOrderedSet, NSArray, etc)
        
        NSMutableArray *values = [[NSMutableArray alloc] init];
        for (id obj in object) {
            [values addObject:SKQueryString(obj)];
        }
        result = [values componentsJoinedByString:@";"];
        [values release];
    } else if ([object isKindOfClass:[NSIndexSet class]]) {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        [object enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [values addObject:[NSString stringWithFormat:@"%lu", idx]];
        }];
        result = SKQueryString(values);
        [values release];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        result = [NSString stringWithFormat:@"%ld", [object integerValue]];
    } else if ([object isKindOfClass:[NSDate class]]) {
        NSNumber * n = [NSNumber numberWithDouble:[object timeIntervalSince1970]];
        result = SKQueryString(n);
    } else if ([object isKindOfClass:[NSString class]]) {
        NSMutableString *output = [NSMutableString string];
        const unsigned char * source = (const unsigned char *)[object UTF8String];
        int sourceLen = strlen((const char *)source);
        for (int i = 0; i < sourceLen; ++i) {
            const unsigned char thisChar = source[i];
            if (thisChar == ' '){
                [output appendString:@"+"];
            } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || 
                       (thisChar >= 'a' && thisChar <= 'z') ||
                       (thisChar >= 'A' && thisChar <= 'Z') ||
                       (thisChar >= '0' && thisChar <= '9')) {
                [output appendFormat:@"%c", thisChar];
            } else {
                [output appendFormat:@"%%%02X", thisChar];
            }
        }
        result = output;
    }
    
    return result;
}

NSDictionary* SKDictionaryFromQueryString(NSString *query) {
    NSArray *values = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    for (NSString *pair in values) {
        NSArray *bits = [pair componentsSeparatedByString:@"="];
        if ([bits count] != 2) { continue; }
        
        NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        [pairs setObject:value forKey:key];
    }
    return pairs;
}

NSURL* SKConstructAPIURL(NSString *path, NSDictionary *query) {
    NSMutableDictionary *queryWithFilter = [NSMutableDictionary dictionaryWithObject:@"!6W.6d3ciLKGQI" forKey:SKQueryKeys.filter];
    [queryWithFilter addEntriesFromDictionary:query];
    NSString *queryString = SKQueryString(queryWithFilter);
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.stackexchange.com/2.0/%@?%@", path, queryString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

SKResponse* SKExecuteAPICall(NSURL *url) {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error = nil;
    
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data == nil) { return nil; }
    
    NSDictionary *responseObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([responseObjects isKindOfClass:[NSDictionary class]] == NO) {
        if (error) {
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"JSON response not a dictionary", NSLocalizedDescriptionKey,
                                  error, NSUnderlyingErrorKey,
                                  nil];
            error = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInternalError userInfo:info];
        }
        responseObjects = nil;
    }
    
    if (responseObjects == nil) { return nil; }
    
    return [SKResponse responseFromJSON:responseObjects error:error];

}

// assumes the "string" parameter is all lowercase
NSString *SKCapitalizeStringForProperty(NSString *string, BOOL wouldBeFirst) {
    if ([string isEqualToString:@"api"]) { return @"API"; }
    if ([string isEqualToString:@"url"]) { return @"URL"; }
    if ([string isEqualToString:@"id"]) { return @"ID"; }
    
    if (wouldBeFirst) { return string; }
    
    return [string capitalizedString];
}

// "api_site_parameter" => "APISiteParameter"
// "launch_date" => "launchDate"
// etc
NSString *SKInferPropertyNameFromAPIKey(NSString *APIKey) {
    NSArray *words = [[APIKey lowercaseString] componentsSeparatedByString:@"_"];
    
    NSString *first = SKCapitalizeStringForProperty([words objectAtIndex:0], YES);
    NSMutableArray *bits = [NSMutableArray arrayWithObject:first];
    for (NSUInteger i = 1; i < [words count]; ++i) {
        NSString *word = [words objectAtIndex:i];
        [bits addObject:SKCapitalizeStringForProperty(word, NO)];
    }
    return [bits componentsJoinedByString:@""];
}

NSString *SKInferAPIKeyFromPropertyName(NSString *propertyName) {
    NSString *lower = [propertyName lowercaseString];
    NSMutableString *key = [NSMutableString string];
    for (NSUInteger i = 0; i < [propertyName length]; ++i) {
        unichar character = [propertyName characterAtIndex:i];
        if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:character]) {
            character = [lower characterAtIndex:i];
            [key appendString:@"_"];
        }
        [key appendFormat:@"%C", character];
    }
    return key;
}
