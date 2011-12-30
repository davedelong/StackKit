//
//  SKFunctions.h
//  StackKit
//
//  Created by Dave DeLong on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* SKApplicationSupportDirectory();

extern void SKQLog(NSString *format, ...);

extern NSString* SKQueryString(id object);

extern NSURL* SKConstructAPIURL(NSString *path, NSDictionary *query);