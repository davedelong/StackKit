//
//  SKFunctions.h
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKResponse;

extern NSString* SKApplicationSupportDirectory();
extern NSBundle* SKBundle();

extern void SKQLog(NSString *format, ...);

extern NSString* SKQueryString(id object);
extern NSDictionary* SKDictionaryFromQueryString(NSString *query);

extern NSURL* SKConstructAPIURL(NSString *path, NSDictionary *query);
extern SKResponse* SKExecuteAPICall(NSURL *url);

extern NSString *SKInferPropertyNameFromAPIKey(NSString *APIKey);
extern NSString *SKInferAPIKeyFromPropertyName(NSString *propertyName);
