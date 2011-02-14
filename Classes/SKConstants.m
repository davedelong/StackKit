//
//  SKConstants.m
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
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

#import "SKConstants.h"
#import "SKConstants_Internal.h"

NSString * const SKAPIVersion = @"1.1";

NSUInteger const SKPageSizeLimitMax = 100;

#pragma mark -
#pragma mark Placeholders
NSString * const SKTagsParticipatedInByUser = @"user_tags";

#pragma mark -
#pragma mark Error Constants
NSString * const SKErrorDomain = @"com.stackkit";
NSString * const SKExceptionInvalidHandler = @"com.stackkit.skfetchrequest.handler";
NSString * const SKExceptionInvalidRequest = @"com.stackkit.skfetchrequest";

#pragma mark Error codes
NSUInteger const SKErrorCodeNotImplemented = 1;
NSUInteger const SKErrorCodeInvalidEntity = 2;
NSUInteger const SKErrorCodeInvalidPredicate = 3;
NSUInteger const SKErrorCodeUnknownError = 4;

NSInteger const SKErrorCodeNotFound = 404;
NSInteger const SKErrorCodeInternalServerError = 500;

NSInteger const SKErrorCodeInvalidApplicationPublicKey = 4000;
NSInteger const SKErrorCodeInvalidPageSize = 4001;
NSInteger const SKErrorCodeInvalidSort = 4002;
NSInteger const SKErrorCodeInvalidOrder = 4003;
NSInteger const SKErrorCodeRequestRateExceeded = 4004;
NSInteger const SKErrorCodeInvalidVectorFormat = 4005;
NSInteger const SKErrorCodeTooManyIds = 4006;
NSInteger const SKErrorCodeUnconstrainedSearch = 4007;
NSInteger const SKErrorCodeInvalidTags = 4008;
