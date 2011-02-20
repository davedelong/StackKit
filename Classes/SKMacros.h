/** Helper Macros
 
 These are the macros used by StackKit for brevity.
 
 */

#import <Foundation/Foundation.h>
#import "SKFunctions.h"

#pragma mark -
#pragma mark Helpher Macros

#ifndef SK_BOX
#define SK_BOX(o,...) _sk_boxOperators(o, ##__VA_ARGS__, NSNotFound)
#endif

#ifndef SK_EREASON
#define SK_EREASON(o,...) [NSDictionary dictionaryWithObject:[NSString stringWithFormat:(o), ##__VA_ARGS__] forKey:NSLocalizedDescriptionKey]
#endif

#ifndef SK_SORTERROR
#define SK_SORTERROR(o,...) [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidSort userInfo:SK_EREASON(o, ##__VA_ARGS__)]
#endif

#ifndef SK_PREDERROR
#define SK_PREDERROR(o,...) [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:SK_EREASON(o, ##__VA_ARGS__)]
#endif

#ifndef SK_ENTERROR
#define SK_ENTERROR(o,...) [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidEntity userInfo:SK_EREASON(o, ##__VA_ARGS__)]
#endif

#ifndef SK_GETTER
#define SK_GETTER(t,n) -(t) n { \
NSString *k = @"" #n; \
[self willAccessValueForKey:k]; \
t _r = [self primitiveValueForKey:k]; \
[self didAccessValueForKey:k]; \
return _r; \
}
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
