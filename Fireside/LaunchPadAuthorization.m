//
//  Authorization.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "LaunchPadAuthorization.h"
#import "LaunchPadAccount.h"

@implementation LaunchPadAuthorization

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"expires_at" forPropertyName:@"expiresAt"];
        [self registerClass:[LaunchPadAccount class] forCollectionName:@"accounts"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.expiresAt forKey:@"expiresAt"];
    [encoder encodeObject:self.identity forKey:@"identity"];
    [encoder encodeObject:self.accounts forKey:@"accounts"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.expiresAt = [decoder decodeObjectForKey:@"expiresAt"];
        self.identity = [decoder decodeObjectForKey:@"identity"];
        self.accounts = [decoder decodeObjectForKey:@"accounts"];
    }
    return self;
}

@end
