//
//  CampfireRoom.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireRoom.h"
#import "CampfireUser.h"

@implementation CampfireRoom

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"created_at" forPropertyName:@"createdAt"];
        [self setAlias:@"membership_limit" forPropertyName:@"membershipLimit"];
        [self setAlias:@"active_token_value" forPropertyName:@"activeTokenValue"];
        [self setAlias:@"updated_at" forPropertyName:@"updatedAt"];
        [self setAlias:@"open_to_guests" forPropertyName:@"openToGuests"];
        
        [self registerClass:[CampfireUser class] forCollectionName:@"users"];
    }
    return self;
}

@end
