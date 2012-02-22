//
//  SKBareFetchRequest.h
//  StackKit
//
//  Created by Dave DeLong on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKFetchRequest.h"

@interface SKBareFetchRequest : SKFetchRequest

@property (nonatomic, retain) NSURL *url;

+ (id)bareFetchRequestWithURL:(NSURL *)url;

@end
