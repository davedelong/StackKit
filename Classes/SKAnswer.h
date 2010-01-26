//
//  SKAnswer.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKQAPost.h"

@class SKQuestion;

@interface SKAnswer : SKQAPost {
	SKQuestion * question;
	NSArray * comments;
}

@property (readonly) SKQuestion * question;
@property (readonly) NSArray * comments;

@end
