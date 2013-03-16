//
//  Account.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "LaunchPadAccount.h"

@implementation LaunchPadAccount

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.product forKey:@"product"];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.href forKey:@"href"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.product = [decoder decodeObjectForKey:@"product"];
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.href = [decoder decodeObjectForKey:@"href"];
    }
    return self;
}

@end
