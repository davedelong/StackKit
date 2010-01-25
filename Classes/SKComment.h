//
//  SKComment.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPost.h"

@class SKAnswer;

@interface SKComment : SKPost {
	SKAnswer * answer;
}

@property (readonly) SKAnswer * answer;

@end
