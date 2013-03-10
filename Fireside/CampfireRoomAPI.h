//
//  CampfireRoomAPI.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CampfireRoom.h"

@interface CampfireRoomAPI : NSObject

+ (void) getRoomsSuccess:(void (^)(NSArray* rooms))success
                 failure:(void (^)(NSError* error))failure;

+ (void) getRoomsPresentlyInSuccess:(void (^)(NSArray* roomsPresentlyIn))success
                            failure:(void (^)(NSError* error))failure;

+ (void) getRoomDetails:(CampfireRoom*)room
                success:(void (^)(CampfireRoom* room))success
                failure:(void (^)(NSError* error))failure;

+ (void) updateRoom:(CampfireRoom*)room name:(NSString*)name topic:(NSString*)topic success:(void (^)(void))success
            failure:(void (^)(NSError* error))failure;

+ (void) lockRoom:(CampfireRoom*)room success:(void (^)(void))success
          failure:(void (^)(NSError* error))failure;

+ (void) unlockRoom:(CampfireRoom*)room success:(void (^)(void))success
            failure:(void (^)(NSError* error))failure;

+ (void) joinRoom:(CampfireRoom*)room success:(void (^)(void))success
          failure:(void (^)(NSError* error))failure;

+ (void) leaveRoom:(CampfireRoom*)room success:(void (^)(void))success
           failure:(void (^)(NSError* error))failure;

@end
