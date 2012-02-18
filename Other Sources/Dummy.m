//
//  Dummy.m
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

#import <Foundation/Foundation.h>
#import "StackKit.h"

int main(int argc, char* argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [SKSite requestSiteWithNameLike:@"stackoverflow" completionHandler:^(SKSite *site, NSError *error) {
        
        SKCommentFetchRequest *comments = [[[[SKFetchRequest requestForFetchingComments] inReplyToUsersWithIDs:115730, nil] sortedByCreationDate] inDescendingOrder];
        [site executeFetchRequest:comments completionHandler:^(NSArray *comments, NSError *error) {
            NSLog(@"comments: %@", comments);
        }];
        
        SKUserFetchRequest *fr = [[SKFetchRequest requestForFetchingUsers] withIDs:220819, nil];
        
        [site executeFetchRequest:fr completionHandler:^(NSArray *users, NSError *error) {
            SKUser *user = [users lastObject];
            
            NSLog(@"id: %lu", [user userID]);
            NSLog(@"rep: %lu", [user reputation]);
            id piURL = [user profileImageURL];
            NSLog(@"%@ (%@)", piURL, [piURL class]);
        
            SKTagFetchRequest *tr = [[SKFetchRequest requestForFetchingTags] usedByUsers:user, nil];
            
            [site executeFetchRequest:tr completionHandler:^(NSArray *tags, NSError *error) {
                NSLog(@"============");
                for (SKTag *tag in tags) {
                    NSLog(@"found: %@ (%p)", [tag name], tag);
                }
                
                SKBadgeFetchRequest *br = [[[SKFetchRequest requestForFetchingBadges] awardedToUsersWithIDs:220819, 115730, nil] tagBasedOnly];
                [site executeFetchRequest:br completionHandler:^(NSArray *badges, NSError *error) {
                    NSLog(@"============== Badges ===================");
                    for(SKBadge *badge in badges) {
                        NSLog(@"found badge (%p) {name: %@, rank: %u, tag based: %@}", badge, [badge name], [badge rank], [badge isTagBased] ? @"YES" : @"NO");
                    }
                    NSLog(@"=========================================");
                }];
            }];
        }];
        
    }];
    
    [[NSRunLoop currentRunLoop] run];
	
	[pool drain];
	return 0;
}