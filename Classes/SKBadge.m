//
//  SKBadge.m
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

NSString * SKBadgeID = @"badge_id";
NSString * SKBadgeRank = @"rank";
NSString * SKBadgeName = @"name";
NSString * SKBadgeDescription = @"description";
NSString * SKBadgeAwardCount = @"award_count";
NSString * SKBadgeTagBased = @"tag_based";
NSString * SKBadgesAwardedToUser = __SKUserID;

NSString * SKBadgeRankGoldKey = @"gold";
NSString * SKBadgeRankSilverKey = @"silver";
NSString * SKBadgeRankBronzeKey = @"bronze";

@implementation SKBadge

@synthesize name;
@synthesize description;
@synthesize badgeID;
@synthesize rank;
@synthesize numberAwarded;
@synthesize tagBased;

#pragma mark SKObject methods:

- (id) initWithSite:(SKSite *)aSite dictionaryRepresentation:(NSDictionary *)dictionary {
	if (self = [super initWithSite:aSite]) {
		badgeID = [[dictionary objectForKey:SKBadgeID] retain];
		description = [[dictionary objectForKey:SKBadgeDescription] retain];
		name = [[dictionary objectForKey:SKBadgeName] retain];
		
		numberAwarded = [[dictionary objectForKey:SKBadgeAwardCount] retain];
		
		rank = SKBadgeRankBronze;
		if ([[dictionary objectForKey:SKBadgeRank] isEqual:SKBadgeRankGoldKey]) {
			rank = SKBadgeRankGold;
		} else if ([[dictionary objectForKey:SKBadgeRank] isEqual:SKBadgeRankSilverKey]) {
			rank = SKBadgeRankSilver;
		}
		
		tagBased = [[dictionary objectForKey:SKBadgeTagBased] boolValue];
	}
	return self;
}

+ (NSDictionary *) APIAttributeToPropertyMapping {
	static NSDictionary * _kSKBadgeMappings = nil;
	if (_kSKBadgeMappings == nil) {
		_kSKBadgeMappings = [[NSDictionary alloc] initWithObjectsAndKeys:
							 @"name", SKBadgeName,
							 @"description", SKBadgeDescription,
							 @"ID", SKBadgeID,
							 @"rank", SKBadgeRank,
							 @"numberAwarded", SKBadgeAwardCount,
							 @"tagBased", SKBadgeTagBased,
							 @"userID", SKUserID,
							 nil];
	}
	return _kSKBadgeMappings;
}

+ (NSString *) dataKey {
	return @"badges";
}

+ (NSArray *) endpoints {
	return [NSArray arrayWithObjects:
			[SKAllBadgesEndpoint class],
			[SKNameBadgesEndpoint class],
			[SKTagBadgesEndpoint class],
			[SKUserBadgesEndpoint class],
			nil];
}

#pragma mark SKBadge-specific methods

- (BOOL) isEqual:(id)object {
	if ([object isKindOfClass:[self class]] == NO) { return NO; }
	return ([[self badgeID] isEqual:[object badgeID]]);
}

- (void)dealloc
{
	[name release];
	[description release];
	[badgeID release];
	[numberAwarded release];
	[super dealloc];
}

@end
