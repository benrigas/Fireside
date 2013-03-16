//
//  CampfireMessageAPI.m
//  Fireside
//
//  Created by Ben Rigas on 3/10/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireMessageAPI.h"
#import "AFHTTPRequestOperation.h"

@implementation CampfireMessageAPI

// speak message
+ (void) speakMessage:(CampfireMessage*)message toRoom:(CampfireRoom*)room success:(void (^)(CampfireMessage* message))success
              failure:(void (^)(NSError* error))failure {
    
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@/speak.json", room.id];
    NSDictionary* params = @{@"message": [message attributes]};
    
    //NSLog(@"params: %@", params);
    
    [[CampfireAPIClient sharedInstance] postPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"response from sending: %@", responseObject);
            CampfireMessage* message = [[CampfireMessage alloc] initWithAttributes:[responseObject objectForKey:@"message"]];
            success(message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"resp: %@",operation.responseString);
        if (failure) {
            failure(error);
        }
    }];
}

// get recent messages
+ (void) getRecentMessagesForRoom:(CampfireRoom*)room limit:(NSNumber*)limit sinceMessageId:(NSNumber*)sinceMessageId
                          success:(void (^)(NSArray* recentMessages))success
                          failure:(void (^)(NSError* error))failure {
    NSString* urlPath = [NSString stringWithFormat:@"/room/%@/recent.json", room.id];
    NSMutableDictionary* params = nil;
    
    if (limit || sinceMessageId) {
        params = [[NSMutableDictionary alloc] init];
        if (limit) {
            [params setObject:limit forKey:@"limit"];
        }
        
        if (sinceMessageId) {
            [params setObject:sinceMessageId forKey:@"since_message_id"];
        }
    }
    
    [[CampfireAPIClient sharedInstance] getPath:urlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"recent messages\n%@", responseObject);
            NSMutableArray* recentMessages = [[NSMutableArray alloc] init];
            for (NSDictionary* attributes in [responseObject objectForKey:@"messages"]) {
                CampfireMessage* message = [[CampfireMessage alloc] initWithAttributes:attributes];
                [recentMessages addObject:message];
            }
            success(recentMessages);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// star message

// unstar message

@end
