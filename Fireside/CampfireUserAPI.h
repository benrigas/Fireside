//
//  CampfireUserAPI.h
//  Fireside
//
//  Created by Ben Rigas on 3/21/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CampfireUser.h"

@interface CampfireUserAPI : NSObject

+ (id)sharedInstance;

- (void) getUserWithId:(NSNumber*)userId
               success:(void (^)(CampfireUser* user))success
               failure:(void (^)(NSError* error))failure;

@end
