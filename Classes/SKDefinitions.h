/** Standard defintions and enums
 
 These are the main non-object types used by StackKit, including enums and typedefs.
 */

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>
typedef UIColor SKColor;

#else

#import <Cocoa/Cocoa.h>
typedef NSColor SKColor;

#endif

@class SKSiteStatistics;

typedef void(^SKStatisticsHandler)(SKSiteStatistics *);
typedef void(^SKRequestHandler)(NSArray *);
typedef void(^SKActionBlock)(void);

typedef id (*SKExtractor)(id);

typedef struct _SKRange {
	id lower;
	id upper;
} SKRange;

#define SKNotFound nil

extern SKRange const SKRangeNotFound;

#pragma mark -
#pragma mark Enums

typedef enum {
	SKSiteStateNormal = 0,
	SKSiteStateLinkedMeta = 1,
	SKSiteStateOpenBeta = 2,
	SKSiteStateClosedBeta = 3
} SKSiteState;

typedef enum {
	SKUserTypeAnonymous = 0,
	SKUserTypeUnregistered = 1,
	SKUserTypeRegistered = 2,
	SKUserTypeModerator = 3
} SKUserType_t;

//Enumeration for badge "levels" – bronze, silver or gold
typedef enum {
	SKBadgeRankBronze = 0,
	SKBadgeRankSilver = 1,
	SKBadgeRankGold = 2
} SKBadgeRank_t;

typedef enum {
	SKPostTypeQuestion = 0,
	SKPostTypeAnswer = 1
} SKPostType_t;
