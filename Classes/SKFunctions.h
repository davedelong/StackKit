/** StackKit Functions
 
 These are the functions used in StackKit.  Most of these are used during URL generation.
 */

#import "SKDefinitions.h"

@class SKFetchRequest;

BOOL sk_classIsSubclassOfClass(Class aClass, Class targetSuper);
NSArray* _sk_boxOperators(NSUInteger operator, ...);

void SKQLog(NSString *format, ...);

BOOL SKIsVectorClass(id value);
NSString * SKExtractVector(id value, SKExtractor extractor);
NSString * SKVectorizedCollection(id value);

id SKExtractPostID(id value);
id SKExtractCommentID(id value);
id SKExtractQuestionID(id value);
id SKExtractAnswerID(id value);
id SKExtractUserID(id value);
id SKExtractBadgeID(id value);
id SKExtractTagName(id value);

NSDate * SKExtractDate(id value);
NSUInteger SKExtractInteger(id value);

#ifdef StackKitMobile
UIColor * SKColorFromHexString(NSString * hexString);
#else
NSColor * SKColorFromHexString(NSString * hexString);
#endif
