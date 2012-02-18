//
//  SKAuthenticator_Internal.h
//  StackKit
//
//  Created by Dave DeLong on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKAuthenticator.h"

@interface SKAuthenticator (Private)

@property (nonatomic, readonly, copy) NSString *accessToken;
@property (readonly, retain) NSDate *expiryDate;

@end
