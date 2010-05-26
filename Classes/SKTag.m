//
//  SKTag.m
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

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
		//it must be a comparison predicate
		if ([p isKindOfClass:[NSComparisonPredicate class]] == NO) {
			[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
			return nil;
		}
		
		//the operator must be ==
		NSComparisonPredicate * comparisonP = (NSComparisonPredicate *)p;
		if ([comparisonP predicateOperatorType] != NSEqualToPredicateOperatorType) {
			[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
			return nil;
		}
		
		//the left expression must be a keyPath
		NSExpression * left = [comparisonP leftExpression];
		if ([left expressionType] != NSKeyPathExpressionType) {
			[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
			return nil;
		}
		
		//the left keypath must be SKTagsParticipatedInByUser
		if ([[left keyPath] isEqual:SKTagsParticipatedInByUser] == NO) {
			[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
			return nil;			
		}
		
		//the right expression must be a constantValue
		NSExpression * right = [comparisonP rightExpression];
		if ([right expressionType] != NSConstantValueExpressionType) {
			[request setError:[NSError errorWithDomain:SKErrorDomain code:SKErrorCodeInvalidPredicate userInfo:nil]];
			return nil;
		}
		
		//if we get here, we know the predicate is SKTagsParticipatedInByUser = constantValue
		id user = [p constantValueForLeftExpression:[NSExpression expressionForKeyPath:SKTagsParticipatedInByUser]];
		NSNumber * userID = nil;
		if ([user isKindOfClass:[SKUser class]]) {
			userID = [user userID];
		} else if ([user isKindOfClass:[NSNumber class]]) {
			userID = user;
		} else {
			userID = [NSNumber numberWithInt:[[user description] intValue]];
		}
		path = [NSString stringWithFormat:@"/users/%@/tags", userID];
	} else {
		path = @"/tags";
	}
	
	
	NSMutableDictionary * query = [NSMutableDictionary dictionary];
	[query setObject:[[request site] apiKey] forKey:SKSiteAPIKey];
	
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
	
	NSURL * apiCall = [[self class] constructAPICallForBaseURL:[[request site] apiURL] relativePath:path query:query];
	
	return apiCall;
}

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		name = [[dictionary objectForKey:SKTagName] retain];
		numberOfTaggedQuestions = [[dictionary objectForKey:SKTagCount] unsignedIntegerValue];
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
	
	[super dealloc];
}

@end
