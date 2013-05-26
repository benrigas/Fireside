//
//  CampfireRoomAPI.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireRoomAPI.h"
#import "CampfireAPIClient.h"

@implementation CampfireRoomAPI

// all rooms
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

// all rooms that user is presently in
+ (void) getRoomsPresentlyInSuccess:(void (^)(NSArray* roomsPresentlyIn))success
                 failure:(void (^)(NSError* error))failure {
    
    NSString* urlPath = @"/presence.json";
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

// get room details (with users)
+ (void) getRoomDetails:(CampfireRoom*)room
               success:(void (^)(CampfireRoom* room))success
               failure:(void (^)(NSError* error))failure {
    
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@.json", room.id];
    NSMutableDictionary* params = nil;
    
    [[CampfireAPIClient sharedInstance] getPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"room response: %@", responseObject);
        CampfireRoom* room = [[CampfireRoom alloc] initWithAttributes:responseObject];
        
        if (success) {
            success(room);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// join
+ (void) joinRoom:(CampfireRoom*)room success:(void (^)(void))success
          failure:(void (^)(NSError* error))failure {
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@/join.json", room.id];
    NSMutableDictionary* params = nil;
    
    [[CampfireAPIClient sharedInstance] postPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// leave
+ (void) leaveRoom:(CampfireRoom*)room success:(void (^)(void))success
          failure:(void (^)(NSError* error))failure {
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@/leave.json", room.id];
    NSMutableDictionary* params = nil;
    
    [[CampfireAPIClient sharedInstance] postPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// lock
+ (void) lockRoom:(CampfireRoom*)room success:(void (^)(void))success
          failure:(void (^)(NSError* error))failure {
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@/lock.json", room.id];
    NSMutableDictionary* params = nil;
    
    [[CampfireAPIClient sharedInstance] postPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// unlock
+ (void) unlockRoom:(CampfireRoom*)room success:(void (^)(void))success
          failure:(void (^)(NSError* error))failure {
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@/unlock.json", room.id];
    NSMutableDictionary* params = nil;
    
    [[CampfireAPIClient sharedInstance] postPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// update
+ (void) updateRoom:(CampfireRoom*)room name:(NSString*)name topic:(NSString*)topic success:(void (^)(void))success
          failure:(void (^)(NSError* error))failure {
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@.json", room.id];
    NSMutableDictionary* params = nil;
    
    // easier to just do this here rather than in the data object, since it's kind of a special case (not sending everything)
    if (name || topic) {
        params = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* roomParams = [[NSMutableDictionary alloc] init];
        [params setObject:roomParams forKey:@"room"];
        
        if (name) {
            [roomParams setObject:name forKey:@"name"];
        }
        
        if (topic) {
            [roomParams setObject:topic forKey:@"topic"];
        }
    }
    
    [[CampfireAPIClient sharedInstance] putPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
