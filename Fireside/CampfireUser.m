//
//  CampfireUser.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireUser.h"

@implementation CampfireUser

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.emailAddress forKey:@"emailAddress"];
    [encoder encodeBool:self.admin forKey:@"admin"];
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.emailAddress = [decoder decodeObjectForKey:@"emailAddress"];
        self.admin = [decoder decodeBoolForKey:@"admin"];
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
    }
    return self;
}

@end
