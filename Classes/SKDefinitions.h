//
//  SKDefinitions.h
//  StackKit
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

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
#define __SKPostScore @"score"


#ifndef SKLog
#define SKLog(format,...) \
{ \
NSString *file = [[NSString alloc] initWithUTF8String:__FILE__]; \
printf("[%s:%d] ", [[file lastPathComponent] UTF8String], __LINE__); \
[file release]; \
SKQLog((format),##__VA_ARGS__); \
}
#endif