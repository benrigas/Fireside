//
//  CampfireUserAPI.m
//  Fireside
//
//  Created by Ben Rigas on 3/21/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireUserAPI.h"
#import "CampfireAPIClient.h"

@implementation CampfireUserAPI
{
    NSCache* userCache;
}

+ (id)sharedInstance
{
    static CampfireUserAPI *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[CampfireUserAPI alloc] init];
    });
    
    return __sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        userCache = [[NSCache alloc] init];
    }
    return self;
}

- (void) getUserWithId:(NSNumber*)userId
               success:(void (^)(CampfireUser* user))success
               failure:(void (^)(NSError* error))failure {
    
    CampfireUser* cachedUser = nil;
    if ((cachedUser = [userCache objectForKey:userId])) {
        //NSLog(@"%@ is cached!", userId);
        if (success) {
            success(cachedUser);
        }
    }
    else {
        NSString* urlPath = [NSString stringWithFormat:@"/users/%@.json", userId];
        NSMutableDictionary* params = nil;
        
        [[CampfireAPIClient sharedInstance] getPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"%@ is not in the cache, fetching it now!", userId);
            CampfireUser* user = [[CampfireUser alloc] initWithAttributes:[responseObject objectForKey:@"user"]];
            
            if (success) {
                success(user);
                [userCache setObject:user forKey:userId];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

@end
