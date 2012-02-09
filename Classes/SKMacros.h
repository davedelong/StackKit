//
//  SKMacros.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#ifndef StackKitMobile
#define StackKitMobile 
#endif

#else

#ifndef StackKitMac
#define StackKitMac 
#endif

#endif

#ifndef SKLog
#define SKLog(format,...) \
{ \
NSString *file = [[NSString alloc] initWithUTF8String:__FILE__]; \
printf("[%s:%d] ", [[file lastPathComponent] UTF8String], __LINE__); \
[file release]; \
SKQLog((format),##__VA_ARGS__); \
}
#endif

// totally cribbed from https://github.com/uliwitness/UliKit/blob/master/UKHelperMacros.h
#define PROPERTY(propName)	NSStringFromSelector(@selector(propName))

#define REQUIRE_CLASS(_c) { \
if (self != (_c)) { \
[NSException raise:NSInternalInconsistencyException format:@"%s may only be invoked on %@", __PRETTY_FUNCTION__, (_c)]; \
} \
}

#define REQUIRE_OVERRIDE { \
[NSException raise:NSInternalInconsistencyException format:@"%s must be overridden by subclasses", __PRETTY_FUNCTION__]; \
}