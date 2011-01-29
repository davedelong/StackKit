//
//  SKAnswer+Private.h
//  StackKit
//
//  Created by Dave DeLong on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKAnswer.h"

@interface SKAnswer (Private)

@property (nonatomic, retain) NSNumber * accepted;
@property (nonatomic, retain) SKQuestion * question;

@end
