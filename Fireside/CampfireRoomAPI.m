//
//  CampfireRoomAPI.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireRoomAPI.h"
#import "CampfireAPIClient.h"
#import "CampfireRoom.h"

@implementation CampfireRoomAPI

+ (void) getRoomsSuccess:(void (^)(NSArray* rooms))success
                 failure:(void (^)(NSError* error))failure {
    
    NSString* urlPath = @"/rooms.json";
    NSMutableDictionary* params = nil;
    
    [[CampfireAPIClient sharedInstance] getPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray* rooms = [NSMutableArray array];
        for (NSDictionary* attributes in [responseObject objectForKey:@"rooms"]) {
            CampfireRoom* room = [[CampfireRoom alloc] initWithAttributes:attributes];
            [rooms addObject:room];
        }
     
        if (success) {
            success(rooms);
        }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void) getRoomsPresentlyInSuccess:(void (^)(NSArray* roomsPresentlyIn))success
                 failure:(void (^)(NSError* error))failure {
    
    NSString* urlPath = @"/presence.json";
    NSMutableDictionary* params = nil;
    
    [[CampfireAPIClient sharedInstance] getPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray* rooms = [NSMutableArray array];
        for (NSDictionary* attributes in responseObject) {
            CampfireRoom* room = [[CampfireRoom alloc] initWithAttributes:attributes];
            [rooms addObject:room];
        }
        
        if (success) {
            success(rooms);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end
