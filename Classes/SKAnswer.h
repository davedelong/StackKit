//
//  SKAnswer.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKQAPost.h"

@class SKQuestion;

@interface SKAnswer :  SKQAPost  
{
}

@property (nonatomic, retain, readonly) NSNumber * accepted;
@property (nonatomic, retain, readonly) SKQuestion * question;

@end



