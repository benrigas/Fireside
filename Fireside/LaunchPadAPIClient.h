//
//  CampfireAPIClient.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "AFHTTPClient.h"

@interface LaunchPadAPIClient : AFHTTPClient

+ (id)sharedInstance;

@end
