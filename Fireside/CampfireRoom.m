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

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.topic forKey:@"topic"];
    [encoder encodeObject:self.membershipLimit forKey:@"membershipLimit"];
    [encoder encodeObject:self.full forKey:@"full"];
    [encoder encodeObject:self.openToGuests forKey:@"openToGuests"];
    [encoder encodeObject:self.activeTokenValue forKey:@"activeTokenValue"];
    [encoder encodeObject:self.updatedAt forKey:@"updatedAt"];
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:self.users forKey:@"users"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.topic = [decoder decodeObjectForKey:@"topic"];
        self.membershipLimit = [decoder decodeObjectForKey:@"membershipLimit"];
        self.full = [decoder decodeObjectForKey:@"full"];
        self.openToGuests = [decoder decodeObjectForKey:@"openToGuests"];
        self.activeTokenValue = [decoder decodeObjectForKey:@"activeTokenValue"];
        self.updatedAt = [decoder decodeObjectForKey:@"updatedAt"];
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
        self.users = [decoder decodeObjectForKey:@"users"];
    }
    return self;
}

@end
