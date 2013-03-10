//
//  CampfireRoomAPI.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CampfireRoomAPI : NSObject

+ (void) getRoomsSuccess:(void (^)(NSArray* rooms))success
                 failure:(void (^)(NSError* error))failure;

+ (void) getRoomsPresentlyInSuccess:(void (^)(NSArray* roomsPresentlyIn))success
                            failure:(void (^)(NSError* error))failure;

@end
