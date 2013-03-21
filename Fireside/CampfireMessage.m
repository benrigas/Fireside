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

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.roomId forKey:@"roomId"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.body forKey:@"body"];
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.starred forKey:@"starred"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeObject:self.url forKey:@"url"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.roomId = [decoder decodeObjectForKey:@"roomId"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.body = [decoder decodeObjectForKey:@"body"];
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.starred = [decoder decodeObjectForKey:@"starred"];
        self.description = [decoder decodeObjectForKey:@"description"];
        self.url = [decoder decodeObjectForKey:@"url"];
    }
    return self;
}

@end
