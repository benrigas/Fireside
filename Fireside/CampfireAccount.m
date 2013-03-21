//
//  CampfireAccount.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireAccount.h"

@implementation CampfireAccount

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.subdomain forKey:@"subdomain"];
    [encoder encodeObject:self.plan forKey:@"plan"];
    [encoder encodeObject:self.ownerId forKey:@"ownerId"];
    [encoder encodeObject:self.timeZone forKey:@"timeZone"];
    [encoder encodeObject:self.storageType forKey:@"storageType"];
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:self.updatedAt forKey:@"updatedAt"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.subdomain = [decoder decodeObjectForKey:@"subdomain"];
        self.plan = [decoder decodeObjectForKey:@"plan"];
        self.ownerId = [decoder decodeObjectForKey:@"ownerId"];
        self.timeZone = [decoder decodeObjectForKey:@"timeZone"];
        self.storageType = [decoder decodeObjectForKey:@"storageType"];
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
        self.updatedAt = [decoder decodeObjectForKey:@"updatedAt"];
    }
    return self;
}

@end
