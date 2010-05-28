//
//  SKDefinitions.h
//  StackKit
//
//  Created by Dave DeLong on 5/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKFunctions.h"

/**
 There are some cases where constants can have different names but the same value.  For example:
 - in SKUser:	SKUserID
 - in SKTag:	SKTagsParticipatedInByUser
 - in SKBadge:	SKBadgeAwardedToUser
 
 All three of those have the value of @"user_id", but it doesn't always make contextual sense to refer to them all as SKUserID.
 An SKBadge, for example, does not have an SKUserID.  However, it does know if it has been awarded to a particular user.
 
 To get around the trouble of defining @"user_id" in 3 different places, all three of these constants are declared like so:
 
 NSString * const SKWhateverThisConstantIs = __SKUserID;
 
__SKUserID is #defined below to be @"user_id".
 
 For reference, see http://stackoverflow.com/questions/2909724
 
 **/

#define __SKUserID @"user_id"


#ifndef SKLog
#define SKLog(format,...) \
{ \
NSString *file = [[NSString alloc] initWithUTF8String:__FILE__]; \
printf("[%s:%d] ", [[file lastPathComponent] UTF8String], __LINE__); \
[file release]; \
SKQLog((format),##__VA_ARGS__); \
}
#endif