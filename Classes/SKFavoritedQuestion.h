//
//  SKFavoritedQuestion.h
//  StackKit
//
//  Created by Dave DeLong on 2/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SKObject.h"

@class SKQuestion, SKUser;

@interface SKFavoritedQuestion : SKObject {

}

@property (nonatomic, readonly) NSDate * favoritedDate;
@property (nonatomic, readonly) SKUser * user;
@property (nonatomic, readonly) SKQuestion * question;

@end
