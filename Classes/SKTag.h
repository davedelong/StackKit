//
//  SKTag.h
//  StackKit
//
//  Created by Dave DeLong on 1/25/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKObject.h"

extern NSString * SKTagName;
extern NSString * SKTagCount;
extern NSString * SKTagsParticipatedInByUser;

@interface SKTag : SKObject {
	NSString *name;
	
	NSNumber * numberOfTaggedQuestions;
}

@property (readonly) NSString *name;
@property (readonly) NSNumber * numberOfTaggedQuestions;

@end
