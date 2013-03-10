//
//  CampfireMessage.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireMessage.h"

@implementation CampfireMessage

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"room_id" forPropertyName:@"roomId"];
        [self setAlias:@"user_id" forPropertyName:@"userId"];
        [self setAlias:@"created_at" forPropertyName:@"createdAt"];
    }
    return self;
}

@end
