//
//  SKTag.m
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

#import "StackKit_Internal.h"

NSString * SKTagName = @"name";
NSString * SKTagCount = @"count";
NSString * SKTagsParticipatedInByUser = __SKUserID;

NSUInteger SKTagDefaultPageSize = 70;

@implementation SKTag

@synthesize name;
@synthesize numberOfTaggedQuestions;

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKTagMappings = nil;
	if (_kSKTagMappings == nil) {
		_kSKTagMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
							 @"name", SKTagName,
							 @"numberOfTaggedQuestions", SKTagCount,
							 nil];
	}
	return _kSKTagMappings;
}

+ (NSString *) dataKey {
	return @"tags";
}

+ (NSDictionary *) validPredicateKeyPaths {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			SKTagsParticipatedInByUser, SKTagsParticipatedInByUser, 
			nil];
}

+ (NSURL *) apiCallForFetchRequest:(SKFetchRequest *)request {
	/**
	 Valid endpoints:
	 
	 /tags
	 /users/{id}/tags
	 
	 This means the only valid predicate is:
	 SKTagsParticipatedInByUser = ##
	 
	 **/
	NSString * path = nil;
	NSPredicate * p = [request predicate];
	if (p != nil) {
		
		NSArray * validKeyPaths = [NSArray arrayWithObject:SKTagsParticipatedInByUser];
		if ([p isComparisonPredicateWithLeftKeyPaths:validKeyPaths 
											operator:NSEqualToPredicateOperatorType 
								 rightExpressionType:NSConstantValueExpressionType] == NO) {
			return SKInvalidPredicateErrorForFetchRequest(request, nil);
		}
		
		//if we get here, we know the predicate is SKTagsParticipatedInByUser = constantValue
		id user = [p constantValueForLeftKeyPath:SKTagsParticipatedInByUser];
		NSNumber * userID = SKExtractUserID(user);
		path = [NSString stringWithFormat:@"/users/%@/tags", userID];
	} else {
		path = @"/tags";
	}
	
	
	NSMutableDictionary * query = [request defaultQueryDictionary];
	
	if ([request fetchOffset] != 0 || [request fetchLimit] != 0) {
		NSUInteger pagesize = ([request fetchLimit] > 0 ? [request fetchLimit] : SKTagDefaultPageSize);
		NSUInteger page = ([request fetchOffset] > 0 ? floor([request fetchOffset]/pagesize) : 1);
		
		[query setObject:[NSNumber numberWithUnsignedInteger:pagesize] forKey:SKPageSizeKey];
		[query setObject:[NSNumber numberWithUnsignedInteger:page] forKey:SKPageKey];
	}
	
	//TODO: sorting
/**	//Add sorting to the query
	NSString * sort = @"activity";
	NSSortDescriptor * mainDescriptor = nil;
	for (NSSortDescriptor * sortDescriptor in [request sortDescriptors]) {
		NSString * key = [[self class] propertyKeyFromAPIAttributeKey:[sortDescriptor key]];
		mainDescriptor = sortDescriptor;
		if ([key isEqual:[[self class] propertyKeyFromAPIAttributeKey:SKTagName]]) {
			sort = @"name";
			break;
		} else if ([key isEqual:[[self class] propertyKeyFromAPIAttributeKey:SKTagCount]]) {
			sort = @"popular";
			break;
		}
	}
	NSString * order = ([mainDescriptor ascending] ? @"asc" : @"desc");
	
	[query setObject:sort forKey:SKSortKey];
	[query setObject:order forKey:SKSortOrderKey];
 **/
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:[[request site] APIURL] relativePath:path query:query];
	
	return apiCall;
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		name = [[dictionary objectForKey:SKTagName] retain];
		numberOfTaggedQuestions = [[dictionary objectForKey:SKTagCount] retain];
	}
	return self;
}

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) {
		return NO;
	}
	
	return [[self name] isEqual:[object name]];
}

- (void) dealloc {
	[name release];
	[numberOfTaggedQuestions release];
	[super dealloc];
}

@end
