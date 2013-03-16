//
//  Identity.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "LaunchPadIdentity.h"

@implementation LaunchPadIdentity

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"email_address" forPropertyName:@"emailAddress"];
        [self setAlias:@"first_name" forPropertyName:@"firstName"];
        [self setAlias:@"last_name" forPropertyName:@"lastName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.emailAddress forKey:@"emailAddress"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.emailAddress = [decoder decodeObjectForKey:@"emailAddress"];
    }
    return self;
}

@end
