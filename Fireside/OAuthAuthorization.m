//
//  Authorization.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "OAuthAuthorization.h"

@implementation OAuthAuthorization

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"refresh_token" forPropertyName:@"refreshToken"];
        [self setAlias:@"access_token" forPropertyName:@"accessToken"];
        [self setAlias:@"expires_in" forPropertyName:@"expirationDate"];
        
        [self addFormatterForPropertyName:@"expirationDate" input:^id(id expiresIn) {
            return [[NSDate date] dateByAddingTimeInterval:[expiresIn doubleValue]];
        } output:nil];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [encoder encodeObject:self.expirationDate forKey:@"expirationDate"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
        self.expirationDate = [decoder decodeObjectForKey:@"expirationDate"];
    }
    return self;
}

@end
