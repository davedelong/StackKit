//
//  SKMacros.h
//  StackKit
//
//  Created by Dave DeLong on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#define StackKitMobile 1
#define StackKitMac 0

#else

#define StackKitMac 1
#define StackKitMobile 0

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

#define REQUIRE_MAINTHREAD { \
if ([NSThread currentThread] != [NSThread mainThread]) { \
[NSException raise:NSInternalInconsistencyException format:@"%s must only be invoked from the main thread", __PRETTY_FUNCTION__]; \
} \
}

#define INTEGER_LIST(_l, _a) { \
if ((_a) > 0) { \
[(_l) addIndex:(_a)]; \
va_list list; \
va_start(list, (_a)); \
\
NSUInteger nextID = 0; \
while ((nextID = va_arg(list, NSUInteger)) != 0) { \
    [(_l) addIndex:nextID]; \
} \
\
va_end(list); \
} \
}

#define OBJECT_LIST(_l, _o, _s) { \
if ((_o) != nil) { \
[(_l) addIndex:[(_o) _s]]; \
va_list list; \
va_start(list, (_o)); \
\
while(((_o) = va_arg(list, id)) != nil) { \
    [(_l) addIndex:[(_o) _s]]; \
} \
\
va_end(list); \
} \
}
