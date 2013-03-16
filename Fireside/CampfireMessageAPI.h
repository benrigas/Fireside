//
//  CampfireMessageAPI.h
//  Fireside
//
//  Created by Ben Rigas on 3/10/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CampfireRoom.h"
#import "CampfireMessage.h"
#import "CampfireAPIClient.h"

@interface CampfireMessageAPI : NSObject

+ (void) speakMessage:(CampfireMessage*)message toRoom:(CampfireRoom*)room success:(void (^)(CampfireMessage* message))success
              failure:(void (^)(NSError* error))failure;

+ (void) getRecentMessagesForRoom:(CampfireRoom*)room limit:(NSNumber*)limit sinceMessageId:(NSNumber*)sinceMessageId
                          success:(void (^)(NSArray* recentMessages))success
                          failure:(void (^)(NSError* error))failure;
@end
